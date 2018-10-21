classdef SpaceConstraint
    %SPACECONSTRAINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        minimalValue
        maximalValue
        precision
        range
        tickCount
    end
    
    methods
        function obj = SpaceConstraint(minimal, maximal, precision)
            obj.minimalValue = minimal;
            obj.maximalValue = maximal;
            obj.precision = precision;
            obj.range = maximal - minimal;
            obj.tickCount = round(obj.range / obj.precision);
        end
        
        function position = CalculatePosition(obj, tick)
            position = obj.minimalValue + tick/obj.tickCount * obj.range;
        end
    end
    
end

