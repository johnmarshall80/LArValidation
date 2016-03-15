void Process(const std::string &filePath, const std::string &fileName)
{
    gROOT->LoadMacro("/usera/marshall/Test/cron/LArReco/validation/Validation.C+");
    Validation(filePath + "/" + fileName, false, false, 0, 100000, 15, 5, true, false, false, "", "TableOutput.txt", "CorrectEventList.txt");

    // ATTN All of the below is just HORRIBLE, but is rather non-invasive to actual development code
    gROOT->SetBatch(kTRUE);
    TCanvas c1;

    TCollection *pCollection(gDirectory->GetList());
    TIterator *pIter = pCollection->MakeIterator();
    TObject *pObject(NULL);

    while (pObject = pIter->Next())
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
