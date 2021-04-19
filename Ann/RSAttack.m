function [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(MEDIA_SOURCE_FILENAME)
%MEDIA_SOURCE_FILENAME           =   'Boat_512_512Marked.bmp';

[MediaSourceA, Mediamap] = imread(MEDIA_SOURCE_FILENAME);
MediaSourceInfo = imfinfo(MEDIA_SOURCE_FILENAME);

MediaImgWidth = MediaSourceInfo.Width;
MediaImgHeight = MediaSourceInfo.Height;

MediaSourceA_64 = double(MediaSourceA(:, :, 1));

M_LENGTH = 2;
M = [1, 1];

G_LENGTH = 2;

Rem_G_M = rem(G_LENGTH, M_LENGTH);

if (Rem_G_M ~= 0)
    return;
end

MediaSourceA_64_M = MediaSourceA_64;
MediaSourceA_64_FM = MediaSourceA_64;

icImgHeight = 1;
icImgWidth = 1;

for icImgHeight = 1 : (MediaImgHeight)
    for icImgWidth = 1 : (MediaImgWidth)
        if (rem(MediaSourceA_64(icImgHeight, icImgWidth), 2) == 0)
            MediaSourceA_64_M(icImgHeight, icImgWidth) = MediaSourceA_64_M(icImgHeight, icImgWidth) + 1;
            MediaSourceA_64_FM(icImgHeight, icImgWidth) = MediaSourceA_64_FM(icImgHeight, icImgWidth) - 1;
        else
            MediaSourceA_64_M(icImgHeight, icImgWidth) = MediaSourceA_64_M(icImgHeight, icImgWidth) - 1;
            MediaSourceA_64_FM(icImgHeight, icImgWidth) = MediaSourceA_64_FM(icImgHeight, icImgWidth) + 1;
         
        end
    end
end

icCount = 1;
R_FM_G = 0;
S_FM_G = 0;
U_FM_G = 0;

R_M_G = 0;
S_M_G = 0;
U_M_G = 0;

for icImgHeight = 1 : (MediaImgHeight)
    for icImgWidth = 1 : G_LENGTH :(MediaImgWidth)
        f_FG = 0;
        f_G = 0;
        for (icCount = 1 : (G_LENGTH - 1))
            f_FMG = f_FG + abs(MediaSourceA_64_FM(icImgHeight, icImgWidth + icCount) - MediaSourceA_64_FM(icImgHeight, icImgWidth + icCount - 1));
            f_MG = f_G + abs(MediaSourceA_64_M(icImgHeight, icImgWidth + icCount) - MediaSourceA_64_M(icImgHeight, icImgWidth + icCount - 1));
            f_G = f_G + abs(MediaSourceA_64(icImgHeight, icImgWidth + icCount) - MediaSourceA_64(icImgHeight, icImgWidth + icCount - 1));
        end
        if (f_FMG > f_G)
            R_FM_G = R_FM_G + 1;
        elseif (f_FMG < f_G)
            S_FM_G = S_FM_G + 1;
        else
            U_FM_G = U_FM_G + 1;
        end
        if (f_MG > f_G)
            R_M_G = R_M_G + 1;
        elseif (f_MG < f_G)
            S_M_G = S_M_G + 1;
        else
            U_M_G = U_M_G + 1;
        end
    end
end

