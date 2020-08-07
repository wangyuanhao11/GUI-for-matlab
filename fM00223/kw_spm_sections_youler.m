function kw_spm_sections_youler(spms,cfg_flipDisp,cfg_package_dir);
%global cfg_flipDisp
global display_aalAD
display_aalAD=1;
global ss;
 ss=GUI2_for_gy();
%spmTN is the number in spmT_000#.img. 
%So, 2 is for spmT_0002.img (the first t-contrast)
%p-value for significance (pvalue=0.001 for example, or pvalue=0.005)
[Finter Fgraph]=spm('FnUIsetup','Stats: Results');
%sh
close(Fgraph);
%sh
swd=pwd;
load(fullfile(swd,'SPM.mat'));
[SPM,xSPM] = spm_getSPM(SPM); %in that program, set no-corrected at p=0.005 kwc
%[SPM,VOL,xX,xCon,xSDM] = kw_getSPM(spmTN,pvalue); %
%hReg=spm_results_ui('SetupGUI',xSPM);
%xSPM.thresDesc = 'none'; %kwc 5/1/19
%[hReg,xSPM,SPM] = spm_results_ui('Setup',[xSPM]); %kwc, it was xSPM

[hReg,xSPM,SPM] = spm_results_ui('Setup',[SPM]); %kwc, now changed to SPM
set(Finter,'visible','off');
%img= "D:\bcheng\gv\bak\workspace\rBannerPET\clinicalad\bannerclinic\spm\canonica\m000-fgeneADoutlined_frnt.nii";
%spm_sections(xSPM,hReg,img);
cfg_flipDisp=0;[spms, sts] = spm_select(1,'image','Select image for rendering on');
spm_sections1(SPM,xSPM,hReg,spms,cfg_flipDisp);
% addpushButton('q');
axes;a=axis;axis('off');
% txtclr='black';
% load patientid
% text((a(2)-a(1))/25,1.04*(a(4)-a(3))/2,[patientNm,' ',pwd] ,'color',...
%         txtclr,'fontsize',8,'interpret','none');
%%keyboard;

return;

function spm_sections1(SPM,VOL,hReg,spms,cfg_flipDisp)
%global cfg_flipDisp
%this is spm99 m-file
% rendering of regional effects [SPM{Z}] on orthogonal sections
% FORMAT spm_sections(SPM,VOL,hReg)
%
% SPM  - SPM structure      {'Z' 'n' 'STAT' 'df' 'u' 'k'}
% VOL  - Spatial structure  {'R' 'FWHM' 'S' 'DIM' 'VOX' 'ORG' 'M' 'XYZ' 'QQ'}
% hReg - handle of MIP register
%
% see spm_getSPM for details
%_______________________________________________________________________
%
% spm_sections is called by spm_results and uses variables in SPM and
% VOL to create three orthogonal sections though a background image.
% Regional foci from the selected SPM are rendered on this image.
%
%_______________________________________________________________________
% @(#)spm_sections.m	2.12	John Ashburner 99/03/31
% ss=test1();
%sh
%Fgraph = spm_figure('FindWin','Graphics');
%kwc: ovlpWithAD and runListR are to compute the degree of overlap of this
%kwc: patient with the AD regions defined by Gene. For now, it is useless
%kwc: so they should be commented out, but they define Fgraph variable :-(
% ovlpWithAD_youler(cfg_package_dir,[SPM.swd,filesep,'spmT_0001.nii']);%kwc
%  Fgraph=ss.UIFigure;
Fgraph =spm_figure('GetWin','Graphics');
spm_results_ui('Clear',Fgraph);
spm_orthviews_for_gui('Reset');
%sh
%Fgraph = spm_figure;
%p=get(Fgraph,'position');
%set(Fgraph,'position',[10 p(2) p(3) p(4)]);
set(Fgraph,'name','Interactive display');close (Fgraph);
%spms   = spm_get(1,'.img','select an image for rendering');
if cfg_flipDisp==0;
%%spms=[fullfile(spm('dir'),'canonical','single_subj_T1.img')];
%spms=[fullfile(spm('dir'),'canonical','geneADoutlined_frnt.img')];
else;
%spms=[fullfile(spm('dir'),'canonical','fsingle_subj_T1.img')];
%spms=[fullfile(spm('dir'),'canonical','m000-fgeneADoutlined_frnt.nii')];
end;
%spm_results_ui('Clear',Fgraph);
spm_orthviews_for_gui('Reset');
global st
st.Space = spm_matrix([0 0 0  0 0 -pi/2])*st.Space;
spm_orthviews_for_gui('Image',spms,[0.05 0.05 0.9 0.45]);
spm_orthviews_for_gui MaxBB;
spm_orthviews_for_gui('register',hReg);
if cfg_flipDisp==1;
    st.Space(1,2)=-st.Space(1,2);
end;
spm_orthviews_for_gui('addblobs',1,VOL.XYZ,VOL.Z,VOL.M);
spm_orthviews_for_gui('Redraw');
