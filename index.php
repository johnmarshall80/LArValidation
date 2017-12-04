<html>
<head>
<title>Pandora Validation</title>
<h1>Pandora Validation</h1>

<head>
    <meta charset="utf-8">
    <title>jQuery UI Datepicker</title>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <link rel="stylesheet" href="/resources/demos/style.css">
    <script>
        $(function() {
        $( "#datepicker" ).datepicker({
          altField: "#alternate",
          altFormat: "DD, d MM, yy",
          dateFormat: "dd-mm-y",
          minDate: new Date(2016, 3 - 1, 10),
          maxDate: "+0D"
        });
        });
    </script>
</head>

<form name="DatePicker" method="post">
    Version:
    <select name="myversion">
        <option value="v04_16_00" <?php echo ($_POST['myversion'] == 'v04_16_00') ? 'selected' : ''; ?> >v04_16_00</option>
        <option value="v05_04_00" <?php echo ($_POST['myversion'] == 'v05_04_00') ? 'selected' : ''; ?> >v05_04_00</option>
        <option value="v05_08_00" <?php echo ($_POST['myversion'] == 'v05_08_00') ? 'selected' : ''; ?> >v05_08_00</option>
     </select>
    Date:
    <input type="text" id="datepicker" name="datepicker"/> <input type="text" size=30 id="alternate" name="alternate"/>
    <input type="submit">
</form>

<body>
    <?php
        $myversion=$_POST['myversion'];
        $mydate=$_POST['datepicker'];
        $myaltDate=$_POST['alternate'];

        echo "<h4>$myversion</h4>";
        echo "<h4>$myaltDate</h4>";

        $mydir="run/".$myversion."_".$mydate;

        if (file_exists($mydir. '/CorrectEventList.txt'))
        {
            echo "List of <a href=$mydir/CorrectEventList.txt>correct events</a><br/><br/>";
        }

        if (file_exists($mydir. '/TableOutput.txt'))
        {
            echo "<p><iframe src='$mydir/TableOutput.txt' frameborder='0' height='400' width='95%'></iframe></p>";
        }

        $files = array('CCQEL_MU_P',
                       'CCQEL_MU_P_NRecoNeutrinos.png',
                       'CCQEL_MU_P_VtxDeltaR.png',
                       'CCQEL_MU_P_MUON_HitsEfficiency.png',
                       'CCQEL_MU_P_PROTON1_HitsEfficiency.png',
                       'CCRES_MU_P_PIZERO',
                       'CCRES_MU_P_PIZERO_NRecoNeutrinos.png',
                       'CCRES_MU_P_PIZERO_VtxDeltaR.png',
                       'CCRES_MU_P_PIZERO_MUON_HitsEfficiency.png',
                       'CCRES_MU_P_PIZERO_PROTON1_HitsEfficiency.png',
                       'CCRES_MU_P_PIZERO_PHOTON1_HitsEfficiency.png',
                       'CCRES_MU_P_PIZERO_PHOTON2_HitsEfficiency.png',
                       'ALL_INTERACTIONS',
                       'ALL_INTERACTIONS_NRecoNeutrinos.png',
                       'ALL_INTERACTIONS_VtxDeltaR.png',
                       'ALL_INTERACTIONS_MUON_HitsEfficiency.png',
                       'ALL_INTERACTIONS_PROTON1_HitsEfficiency.png',
                       'ALL_INTERACTIONS_PHOTON1_HitsEfficiency.png'
                       );

        for ($i = 0; $i < count($files); $i++)
        {
            $image = $mydir.'/'.$files[$i];

            if (!(empty($mydate)) && (strpos($files[$i], 'png') == false))
            {
                echo "<h4>$files[$i]</h4>";
            }

            if (file_exists($image))
            {
                echo "<img src=$image title=$files[$i] width='25%'/>";
            }
        }
    ?> 
</body>
</html>

