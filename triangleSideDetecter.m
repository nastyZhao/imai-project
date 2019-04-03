function [left_sides,right_sides] = triangleSideDetecter(cepstrum,M,rah_num)

left_sides = [];
right_sides = [];
max_rah_loc = M;

for i=1:rah_num
    stamp = 1;
    side_l = max_rah_loc-1;
    side_r = max_rah_loc+1;
    area_old = max_rah_loc;
    while stamp == 1
        area_new = area_old+cepstrum(side_l)+cepstrum(side_r);
        if abs(area_new - area_old) < 1
            left_sides = [left_sides,side_l];
            right_sides = [right_sides,side_r];
            stamp = 0;
        else
            area_old = area_new;
            side_l = side_l - 1;
            side_r = side_r + 1;
        end
    end
    cepstrum(left_sides(i):right_sides(i)) = 0;
    [var_max_rah,max_rah_loc] = max(cepstrum(1:1000));
end

end