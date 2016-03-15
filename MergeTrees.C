void MergeTrees(const std::string &inputTreesName, const std::string &inputTreesRegex, const std::string &outputTreeName)
{
    TChain chain(inputTreesName.c_str());
    chain.Add(inputTreesRegex.c_str());
    chain.Merge(outputTreeName.c_str());
}

