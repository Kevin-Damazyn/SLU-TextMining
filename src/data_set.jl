type DataSet <: FeatureSpace
  clusters::Dict{Any, Cluster}
  vector_sum::FeatureVector
  mdata::Any
  DataSet() = new(Dict{Any,Cluster}(),FeatureVector())
end

# returns the Cluster indexed by [key]
function getindex(ds::DataSet, key)
  return ds.clusters[key]
end

# maps a [key] to a Cluster [c] 
function setindex!(ds::DataSet, c::Cluster, key)
  if haskey(ds, key)
    subtract!(ds.vector_sum,ds[key].vector_sum)
  end
  add!(ds.vector_sum,c.vector_sum)
  ds.clusters[key] = c
end

function length(ds::DataSet)
  size = 0
  for clust in ds.clusters
    size += length(clust[2])
  end
  return size
end

# returns all keys in the DataSet
function keys(ds::DataSet)
  return Base.keys(ds.clusters)
end

# returns all Clusters in the DataSet
function values(ds::DataSet)
  return Base.values(ds.clusters)
end

# check to see if the DataSet is empty.
function isempty(ds::DataSet)
  return Base.isempty(ds.clusters)
end

function haskey(ds::DataSet, key) 
  return Base.haskey(ds.clusters, key)
end

# prints out the dataset cleanly
function display(ds::DataSet)
  print_with_color(:white,string(typeof(ds)))
  k = length(ds.clusters)

  print_with_color(:white," with $k Clusters")
  if k > 0
    print_with_color(:white,":\n")
    if k > 5
      k = 5
    end

    for key in collect(keys(ds))[1:k]
      l = length(ds[key])
      if length(key) > 40
        key = key[1:40]
        key = key*"…"
      end
      print_with_color(:white,"    $key with $l FeatureVectors\n")
    end
    if length(ds) > 5
      print_with_color(:white,"\t\t\t⋮\n")
    end
  end
end

function show(io::IO, ds::DataSet)
  print(io,string(typeof(ds)))
  k = length(ds.clusters)
  print(io," with $k Clusters")
end