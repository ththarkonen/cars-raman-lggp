function [h] = saveResults( fileName, outputLGGP)

    timeStamp = datetime( "now", "Format", "yyyy_MM_dd_hh_mm_ss" );
    saveDirPath = "./models/" + fileName + "-" + string( timeStamp ) + ".mat";
    
    save( saveDirPath, "outputLGGP")
    h = 0;
end