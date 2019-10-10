
mainpath = 'Z:\kwong\mbisfhb\STORM\191003 - STORM_MEF_WT_AF647\';
path = [mainpath,'cell_002.nd2'];
reader = bfGetReader(path);
nfiles = reader.getImageCount();
x = reader.getSizeX();
y = reader.getSizeY();
bytedepth = 2;
imspace = x*y*bytedepth;
nbatch = 1;
%%%Calculate number of files to keep file size below 4GB
t = 1;
imsize = 0;
nbatch = 0;
while imsize < 3.6
    imsize = (x*y*bytedepth*t)/1e9;
    if ~mod(nfiles/t,1)
        nbatch = t;
    end
    t = t+1;
end
%%%

stack = zeros(y,x,nbatch,'uint16');
numbatches = nfiles/nbatch;
c = 1
for batch = 1:numbatches
    batch
    for i = 1:nbatch
        stack(:,:,i) = bfGetPlane(reader,c);
        c = c+1;
    end
    bfsave(stack,[mainpath,'File_',num2str(batch-1),'.ome.tif']);
end