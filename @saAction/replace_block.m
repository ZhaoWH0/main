function replace_block(obj,varargin)
obj.Data.Path = getfullname(varargin{1});
blktyp = get_param(varargin{1}, 'BlockType');
lnkst = get_param(varargin{1},'LinkStatus');
switch lnkst
    case 'none'
        obj.Data.OldBlockSrc = ['built-in/', blktyp];
    case 'implicit'
        % Not available because support for modifying inside
        % library links is not implemented in this version
    case 'resolved'
        obj.Data.OldBlockSrc = get_param(varargin{1},'ReferenceBlock');
    case 'inactive'
        obj.Data.OldBlockSrc = get_param(varargin{1},'AncestorBlock');
    otherwise
end
obj.Data.NewBlockSrc = varargin{2};
dlgparastru = get_param(obj.Data.Path, 'DialogParameters');
if ~isempty(dlgparastru)
    dlgparas = fieldnames(dlgparastru)';
else
    dlgparas = {};
end
dlgparas = [dlgparas, 'ShowName', 'AttributesFormatString'];
paravals = cell(1, numel(dlgparas));
for i=1:numel(dlgparas)
    paravals{i} = get_param(obj.Data.Path, dlgparas{i});
end
% action
newblk = replace_block(obj.Data.Path, blktyp,obj.Data.NewBlockSrc, 'noprompt');
if iscell(newblk)
    newblk = newblk{1};
end
obj.Handle = get_param(newblk, 'Handle');
obj.Property = [dlgparas; paravals];
end