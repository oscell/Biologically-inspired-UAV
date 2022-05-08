classdef Agent < rl.agent.CustomAgent
    % LQRCustomAgent: Creates an LQR Agent for a linear system.
    %
    %   agent = LQRCustomAgent(Q,R,w0) creates a LQR agent
    %             Q is a n-by-n positive definite matrix 
    %             R is a n-by-n positive definite matrix 
    %             K0 is an initial stabilizing feedback gain
    %
    %      * For a discrete-time state-space model SYS, the state-feedback
    %        law u = -Kx  minimizes the cost function
    %
    %             J = Sum {x'Qx + u'Ru}
    %
    %        subject to the state dynamics   x[n+1] = Ax[n] + Bu[n].
    
    % Copyright 2018-2019 The MathWorks Inc.
    
    %% Public Properties
    properties
        % Q
        Q

        % R
        R

        % Feedback gain
        K

        % Discount Factor
        Gamma = 0.95

        % Critic
        Critic

        % Buffer for K
        KBuffer  
        % Number of updates for K
        KUpdate = 1

        % Number for estimator update
        EstimateNum = 10
    end
    
    properties (Access = private)
        Counter = 1
        YBuffer
        HBuffer 
    end
    
    
    %% MAIN METHODS
    methods
        % Constructor
        function obj = LQRCustomAgent(Q,R,InitialK)
            % Check the number of input arguments
            narginchk(3,3);

            % Call the abstract class constructor
            obj = obj@rl.agent.CustomAgent();

            % Set the Q and R matrices
            obj.Q = Q;
            obj.R = R;

            % Define the observation and action spaces
            obj.ObservationInfo = rlNumericSpec([size(Q,1),1]);
            obj.ActionInfo = rlNumericSpec([size(R,1),1]);

            % Create the critic representation
            obj.Critic = createCritic(obj);

            % Initialize the gain matrix
            obj.K = InitialK;

            % Initialize the experience buffers
            obj.YBuffer = zeros(obj.EstimateNum,1);
            num = size(Q,1) + size(R,1);
            obj.HBuffer = zeros(obj.EstimateNum,0.5*num*(num+1));
            obj.KBuffer = cell(1,1000);
            obj.KBuffer{1} = obj.K;
        end
        end
    
    %% Implementation of abstract parent protected methods
    methods (Access = protected)
        function action = getActionWithExplorationImpl(obj,Observation)
            % Given the current observation, select an action
            action = getAction(obj,Observation);
            % Add random noise to action
            num = size(obj.R,1);
            action = action + 0.1*randn(num,1);
        end
        % learn from current experiences, return action with exploration
        % exp = {state,action,reward,nextstate,isdone}
        function action = learnImpl(obj,exp)
            % Parse the experience input
            x = exp{1}{1};
            u = exp{2}{1};
            dx = exp{4}{1};            
            y = (x'*obj.Q*x + u'*obj.R*u);
            num = size(obj.Q,1) + size(obj.R,1);

            % Wait N steps before updating critic parameters
            N = obj.EstimateNum;
            % In the linear case, critic evaluated at (x,u) is Q1 = theta'*h1,
            % critic evaluated at (dx,-K*dx) is Q2 = theta'*h2. The target
            % is to obtain theta such that Q1 - gamma*Q2 = y, that is,
            % theta'*H = y. Following is the least square solution.
            h1 = computeQuadraticBasis(x,u,num);
            h2 = computeQuadraticBasis(dx,-obj.K*dx,num);
            H = h1 - obj.Gamma* h2;
            if obj.Counter<=N
                obj.YBuffer(obj.Counter) = y;
                obj.HBuffer(obj.Counter,:) = H;
                obj.Counter = obj.Counter + 1;
            else
                % Update the critic parameters based on the batch of
                % experiences
                H_buf = obj.HBuffer;
                y_buf = obj.YBuffer;
                theta = (H_buf'*H_buf)\H_buf'*y_buf;
                obj.Critic = setLearnableParameters(obj.Critic,{theta});
                
                % Derive a new gain matrix based on the new critic parameters
                obj.K = getNewK(obj);
                
                % Reset the experience buffers
                obj.Counter = 1;
                obj.YBuffer = zeros(N,1);
                obj.HBuffer = zeros(N,0.5*num*(num+1));    
                obj.KUpdate = obj.KUpdate + 1;
                obj.KBuffer{obj.KUpdate} = obj.K;
            end

            % Find and return an action with exploration
            action = getActionWithExploration(obj,exp{4});
        end
        % Create critic 
        function critic = createCritic(obj)
            nQ = size(obj.Q,1);
            nR = size(obj.R,1);
            n = nQ+nR;
            w0 = 0.1*ones(0.5*(n+1)*n,1);
            critic = rlQValueRepresentation({@(x,u) computeQuadraticBasis(x,u,n),w0},...
                obj.ObservationInfo,obj.ActionInfo);
            critic.Options.GradientThreshold = 1;
        end
        % Update K from critic
        function k = getNewK(obj)
            w = getLearnableParameters(obj.Critic);
            w = w{1};
            nQ = size(obj.Q,1);
            nR = size(obj.R,1);
            n = nQ+nR;
            idx = 1;
            for r = 1:n
                for c = r:n
                    Phat(r,c) = w(idx);
                    idx = idx + 1;
                end
            end
            S  = 1/2*(Phat+Phat');
            Suu = S(nQ+1:end,nQ+1:end);
            Sux = S(nQ+1:end,1:nQ);
            if rank(Suu) == nR
                k = Suu\Sux;
            else
                k = obj.K;
            end
        end       
        
        % Action methods
        function action = getActionImpl(obj,Observation)
            % Given the current state of the system, return an action.
            action = -obj.K*Observation{:};
        end
 
    end
        
end

%% local function
function B = computeQuadraticBasis(x,u,n)
z = cat(1,x,u);
idx = 1;
for r = 1:n
    for c = r:n
        if idx == 1
            B = z(r)*z(c);
        else
            B = cat(1,B,z(r)*z(c));
        end
        idx = idx + 1;
    end
end
end