function slice(arr, first, last)
    local sliced = {}
    for i = first or 1, last or #arr do
        sliced[#sliced+1] = arr[i]
    end
    return sliced
end