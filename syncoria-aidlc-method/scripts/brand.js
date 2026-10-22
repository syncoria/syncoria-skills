// Shared Syncoria brand helpers for docx generation
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
  Header, Footer, AlignmentType, BorderStyle, WidthType, ShadingType,
  VerticalAlign, PageNumber, TabStopType, TabStopPosition, LevelFormat, PageBreak
} = require('docx');

const C = {
  blue:"003056", teal:"005F6B", carbon:"1A1C22",
  ghost:"F9FAFB", mid:"D0DDE8", steel:"6B7F93",
  light:"EEF3F8", white:"FFFFFF", green:"1E7E34", amber:"BA7517", red:"B3261E",
};
const W = 9360;

const bd = (c=C.mid) => ({ style: BorderStyle.SINGLE, size: 4, color: c });
const bds = (c=C.mid) => ({ top:bd(c), bottom:bd(c), left:bd(c), right:bd(c) });
const noBd = { style: BorderStyle.NONE, size: 0, color: "FFFFFF" };
const noBds = { top:noBd, bottom:noBd, left:noBd, right:noBd };

function sp(pt=8){ return new Paragraph({ spacing:{before:0,after:pt*20}, children:[new TextRun("")] }); }
function pb(){ return new Paragraph({ children:[new PageBreak()] }); }
function r(text, opts={}){ return new TextRun({ text, size:21, font:"Montserrat", color:C.carbon, ...opts }); }
function rb(text, opts={}){ return r(text, {bold:true, ...opts}); }
function ri(text, opts={}){ return r(text, {italics:true, ...opts}); }
function code(text){ return new TextRun({ text, size:20, font:"Consolas", color:C.blue }); }

function hdr(title){ return new Header({ children:[ new Paragraph({
  spacing:{before:0,after:100},
  border:{bottom:{style:BorderStyle.SINGLE,size:8,color:C.blue,space:4}},
  tabStops:[{type:TabStopType.RIGHT,position:TabStopPosition.MAX}],
  children:[
    new TextRun({text:"Syncoria",bold:true,size:18,font:"Montserrat",color:C.blue}),
    new TextRun({text:"\t"+title,size:17,font:"Montserrat",color:C.steel}),
  ]
})]}); }

function ftr(note="Confidential — Internal Use Only"){ return new Footer({ children:[ new Paragraph({
  spacing:{before:80,after:0},
  border:{top:{style:BorderStyle.SINGLE,size:4,color:C.mid,space:4}},
  tabStops:[{type:TabStopType.RIGHT,position:TabStopPosition.MAX}],
  children:[
    new TextRun({text:note,size:17,font:"Montserrat",color:C.steel}),
    new TextRun({text:"\tPage ",size:17,font:"Montserrat",color:C.steel}),
    new TextRun({children:[PageNumber.CURRENT],size:17,font:"Montserrat",color:C.steel}),
  ]
})]}); }

function coverBanner(eyebrow, title, subtitle){
  return new Table({
    width:{size:W,type:WidthType.DXA}, columnWidths:[W],
    rows:[new TableRow({children:[ new TableCell({
      width:{size:W,type:WidthType.DXA}, shading:{fill:C.blue,type:ShadingType.CLEAR}, borders:noBds,
      margins:{top:300,bottom:260,left:380,right:380},
      children:[
        new Paragraph({spacing:{before:0,after:50},children:[ new TextRun({text:eyebrow,size:16,font:"Montserrat",color:"8AAEC8",charSpacing:60}) ]}),
        new Paragraph({spacing:{before:0,after:80},children:[ new TextRun({text:title,bold:true,size:34,font:"Montserrat",color:C.white}) ]}),
        new Paragraph({spacing:{before:0,after:0},children:[ new TextRun({text:subtitle,size:18,font:"Montserrat",color:C.mid}) ]}),
      ]
    })]})]
  });
}

function sectionHead(num, title){
  return new Table({
    width:{size:W,type:WidthType.DXA}, columnWidths:[640,W-640],
    rows:[new TableRow({children:[
      new TableCell({ width:{size:640,type:WidthType.DXA}, shading:{fill:C.blue,type:ShadingType.CLEAR}, borders:noBds, margins:{top:120,bottom:120,left:120,right:60}, verticalAlign:VerticalAlign.CENTER,
        children:[new Paragraph({alignment:AlignmentType.CENTER,children:[ new TextRun({text:String(num),bold:true,size:26,font:"Montserrat",color:C.white}) ]})] }),
      new TableCell({ width:{size:W-640,type:WidthType.DXA}, shading:{fill:C.blue,type:ShadingType.CLEAR}, borders:noBds, margins:{top:120,bottom:120,left:200,right:160}, verticalAlign:VerticalAlign.CENTER,
        children:[new Paragraph({children:[ new TextRun({text:title,bold:true,size:24,font:"Montserrat",color:C.white}) ]})] }),
    ]})]
  });
}

function subHead(text){ return new Paragraph({ spacing:{before:220,after:90}, children:[rb(text,{color:C.blue,size:23})] }); }
function body(runs){ return new Paragraph({ spacing:{before:0,after:120}, children: Array.isArray(runs)?runs:[r(runs)] }); }

function calloutBox(label, runsArr, color=C.blue, bg=C.light){
  return new Table({
    width:{size:W,type:WidthType.DXA}, columnWidths:[W],
    rows:[new TableRow({children:[ new TableCell({
      width:{size:W,type:WidthType.DXA}, shading:{fill:bg,type:ShadingType.CLEAR},
      borders:{top:bd(color),bottom:bd(color),right:bd(color),left:{style:BorderStyle.SINGLE,size:20,color:color}},
      margins:{top:130,bottom:130,left:220,right:180},
      children:[
        new Paragraph({spacing:{before:0,after:50},children:[rb(label,{color:color,size:17,allCaps:true})]}),
        ...(Array.isArray(runsArr[0]) ? runsArr.map(rr=>new Paragraph({spacing:{before:0,after:40},children:rr})) : [new Paragraph({spacing:{before:0,after:0},children:runsArr})])
      ]
    })]})]
  });
}

function bul(runs){ return new Paragraph({ numbering:{reference:"bullets",level:0}, spacing:{before:30,after:60}, children:Array.isArray(runs)?runs:[r(runs)] }); }
function num(runs){ return new Paragraph({ numbering:{reference:"nums",level:0}, spacing:{before:30,after:60}, children:Array.isArray(runs)?runs:[r(runs)] }); }
function chk(runs){ return new Paragraph({ numbering:{reference:"checks",level:0}, spacing:{before:30,after:60}, children:Array.isArray(runs)?runs:[r(runs)] }); }

function tbl(headers, rows, widths){
  return new Table({ width:{size:W,type:WidthType.DXA}, columnWidths:widths,
    rows:[
      new TableRow({tableHeader:true, children:headers.map((h,i)=> new TableCell({
        width:{size:widths[i],type:WidthType.DXA}, shading:{fill:C.blue,type:ShadingType.CLEAR}, borders:bds(C.blue),
        margins:{top:70,bottom:70,left:110,right:80}, children:[new Paragraph({children:[rb(h,{color:C.white,size:18})]})] })) }),
      ...rows.map((row,ri2)=> new TableRow({children: row.map((cell,ci)=> new TableCell({
        width:{size:widths[ci],type:WidthType.DXA}, shading:{fill:ri2%2===0?C.white:C.ghost,type:ShadingType.CLEAR}, borders:bds(),
        margins:{top:70,bottom:70,left:110,right:80},
        children:[new Paragraph({children: cell && cell.mono ? [code(cell.t)] : [r(cell && cell.t!==undefined?cell.t:cell,{size:18, bold: cell && cell.b})] })] })) }))
    ]
  });
}

const numbering = {config:[
  {reference:"bullets",levels:[{level:0,format:LevelFormat.BULLET,text:"\u2022",alignment:AlignmentType.LEFT,style:{paragraph:{indent:{left:620,hanging:300}}}}]},
  {reference:"nums",levels:[{level:0,format:LevelFormat.DECIMAL,text:"%1.",alignment:AlignmentType.LEFT,style:{paragraph:{indent:{left:620,hanging:300}}}}]},
  {reference:"checks",levels:[{level:0,format:LevelFormat.BULLET,text:"\u2610",alignment:AlignmentType.LEFT,style:{paragraph:{indent:{left:620,hanging:300}}}}]},
]};

function buildDoc(headerTitle, children, footerNote){
  return new Document({
    numbering,
    styles:{default:{document:{run:{font:"Montserrat",size:21,color:C.carbon}}}},
    sections:[{
      properties:{page:{size:{width:12240,height:15840},margin:{top:1080,right:1080,bottom:1080,left:1080}}},
      headers:{default:hdr(headerTitle)}, footers:{default:ftr(footerNote)}, children
    }]
  });
}

module.exports = {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, AlignmentType, BorderStyle, WidthType, ShadingType, VerticalAlign,
  C, W, bd, bds, noBds, sp, pb, r, rb, ri, code, coverBanner, sectionHead, subHead, body, calloutBox, bul, num, chk, tbl, buildDoc, Packer
};
