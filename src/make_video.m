function [] = make_video( f, name, fps )
v = VideoWriter(name, 'Motion JPEG 2000');

open(v);

for i=2:length(f)
    v.writeVideo(f(i));
end

close(v);

end

