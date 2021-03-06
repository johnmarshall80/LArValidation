void Process(const std::string &filePath, const std::string &fileName)
{
    Parameters parameters;
    parameters.m_mapFileName = filePath + "/TableOutput.txt";
    parameters.m_eventFileName = filePath + "/CorrectEventList.txt";
    parameters.m_histogramOutput = true;
    parameters.m_displayMatchedEvents = false;

    Validation(filePath + "/" + fileName, parameters);

    // ATTN All of the below is just HORRIBLE, but is rather non-invasive to actual development code
    gROOT->SetBatch(kTRUE);
    TCanvas c1;

    TCollection *pCollection(gDirectory->GetList());
    TIterator *pIter = pCollection->MakeIterator();
    TObject *pObject(NULL);

    while ( (pObject = pIter->Next()) )
    {
        TH1F *pHist = reinterpret_cast<TH1F*>(pObject);

        if (pHist)
        {
             c1.cd();

             if (std::string::npos != std::string(pHist->GetName()).find("Hits"))
                 c1.SetLogx(true);

             pHist->Draw();
             c1.SaveAs(std::string(filePath + std::string("/") + std::string(pHist->GetName()) + std::string(".png")).c_str(), "q");
             c1.SetLogx(false);
        }
    }
}
