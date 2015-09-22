function [ c ] = getC( a, b )

c = getC_unsorted(a, b);
c = sort(c,'descend');
end

