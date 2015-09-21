function [ c ] = getC( a, b )

% calculate the coordinates for a and b instead of lengths
for i = 2:length(a)
    a(i) = a(i) + a(i-1);
end

for i = 2:length(b)
    b(i) = b(i) + b(i-1);
end

% put them together
c_coord = unique(sort([a b]));

% make it into distances instead of coordinates
c = zeros(size(c_coord));
c(1) = c_coord(1);
for i=2:length(c_coord)
    c(i) = c_coord(i) - c_coord(i-1);
end
c = sort(c,'descend');
end

