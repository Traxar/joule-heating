function [g, b] = get_geometry(f)
% geometry = get_geometry(file_path)
% parse geometry of given file
% input:    f ... path to file
% output:   g ... geomety data
%           b ... index giving boundary information
%                   0 ... electrically isolated
%                   1 ... grounded
%                   2 ... high voltage

data = readmatrix(f);
assert(size(data,1) > 0);
assert(size(data,2) == 4);
mask = any(isnan(data), 2).';
starts = strfind([1,mask], [1,0]);
ends = strfind([mask,1],[0,1]);
loops = arrayfun(@(s,e)data(s:e,:), starts, ends, 'UniformOutput',0);
assert(~isempty(loops));
n = sum(cellfun(@(l)size(l,1), loops));
g = zeros(10,n);
b = zeros(1,n);
i = 1;
for loop = loops
    l = loop{1};
    inc = size(l,1);
    r = l(:,3); %radius
    g(1,i:i+inc-1) = (r == 0) + 1;
    cw = r >= 0;
    ccw = r < 0;
    s_x = l(:,1);%start_x
    e_x = circshift(l(:,1),-1);%end_x
    s_y = l(:,2);%start_y
    e_y = circshift(l(:,2),-1);%end_y
    g(2,i:i+inc-1) = ccw.*s_x + cw.*e_x;
    g(3,i:i+inc-1) = ccw.*e_x + cw.*s_x;
    g(4,i:i+inc-1) = ccw.*s_y + cw.*e_y;
    g(5,i:i+inc-1) = ccw.*e_y + cw.*s_y;
    g(6,i:i+inc-1) = ccw;%seg_L
    g(7,i:i+inc-1) = cw;%seg_R

    d_y = (e_x-s_x)/2;
    d_x = (s_y-e_y)/2;
    d2 = d_x.*d_x + d_y.*d_y;
    k = sign(-r) .* sqrt(max(r.*r./d2,1)-1);
    
    c_x = (s_x+e_x)/2 + k.*d_x;%center_x
    c_x(r == 0) = 0;
    g(8,i:i+inc-1) = c_x;

    c_y = (s_y+e_y)/2 + k.*d_y;%center_y
    c_y(r == 0) = 0;
    g(9,i:i+inc-1) = c_y;
   
    g(10,i:i+inc-1) = abs(r);%radius

    b(i:i+inc-1) = l(:,4);

    i = i + inc;
end


