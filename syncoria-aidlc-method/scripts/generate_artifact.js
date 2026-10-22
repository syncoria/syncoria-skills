#!/usr/bin/env node
/*
 * Syncoria AI-DLC — Branded Artifact Generator
 * --------------------------------------------------------------
 * Produces any AI-DLC artifact as a house-styled .docx by running
 * branded code — NOT by free-handing layout. This guarantees every
 * artifact matches the Syncoria template set exactly.
 *
 * USAGE:
 *   node generate_artifact.js <spec.json> <output.docx>
 *
 * REQUIRES the 'docx' npm library. If not present, install once:
 *   npm install docx
 * (in the working directory before running, or globally).
 *
 * The spec.json describes the artifact's CONTENT as structured blocks.
 * This script supplies all STYLING (banner, fonts, colors, tables,
 * callouts, sign-off). Claude fills the content; the script owns the brand.
 *
 * SPEC SHAPE (see artifact-specs.md for the exact structure per artifact):
 * {
 *   "artifactNumber": "08",
 *   "artifactName": "Customer-Validated Behavior Specification",
 *   "subtitle": "...",
 *   "meta": [ {"label":"Customer","value":"..."}, ... ],
 *   "aboutBox": "optional intro paragraph",
 *   "blocks": [
 *     {"type":"section","number":"1","title":"..."},
 *     {"type":"subhead","text":"..."},
 *     {"type":"para","runs":[{"t":"text","b":true|false,"i":true|false,"code":true|false,"color":"blue"}]},
 *     {"type":"instruction","text":"..."},        // amber guidance box
 *     {"type":"fill","text":"placeholder","height":600}, // grey fill area
 *     {"type":"callout","label":"...","text":"...","color":"blue|teal|green|amber"},
 *     {"type":"bullets","items":[ [run,...], ... ]},
 *     {"type":"numbers","items":[ [run,...], ... ]},
 *     {"type":"table","headers":[...],"rows":[[cell,...]],"widths":[...]},  // cell: "text" or {"t":"..","mono":true,"b":true}
 *     {"type":"space","pt":8},
 *     {"type":"pagebreak"}
 *   ],
 *   "signoff": true|false      // append customer/Syncoria signature block
 * }
 */
const path = require('path');
const fs = require('fs');
const B = require(path.join(__dirname, 'brand.js'));
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
  AlignmentType, BorderStyle, WidthType, ShadingType, VerticalAlign,
  C, W, bd, bds, noBds, sp, pb, r, rb, ri, code, coverBanner, sectionHead,
  subHead, calloutBox, bul, num, tbl, buildDoc
} = B;

function runFrom(o){
  if (typeof o === 'string') return r(o);
  const opts = {};
  if (o.b) opts.bold = true;
  if (o.i) opts.italics = true;
  if (o.color && C[o.color]) opts.color = C[o.color];
  if (o.code) return code(o.t);
  return r(o.t, opts);
}
function runsFrom(arr){ return (arr||[]).map(runFrom); }

function metaTable(meta){
  // two-column label/value lines
  return meta.map(m => new Paragraph({ spacing:{before:0,after:60}, children:[
    rb((m.label||"")+":  ", {color:C.steel}), r(m.value||"")
  ]}));
}

function aboutBox(text){
  return new Table({ width:{size:W,type:WidthType.DXA}, columnWidths:[W],
    rows:[new TableRow({children:[ new TableCell({
      width:{size:W,type:WidthType.DXA}, shading:{fill:C.light,type:ShadingType.CLEAR},
      borders:{top:bd(),bottom:bd(),left:{style:BorderStyle.SINGLE,size:18,color:C.blue},right:bd()},
      margins:{top:160,bottom:160,left:220,right:200},
      children:[ new Paragraph({spacing:{before:0,after:0},children:[r(text)]}) ]
    })]})]
  });
}

function instructionBox(text){
  return new Table({ width:{size:W,type:WidthType.DXA}, columnWidths:[W],
    rows:[new TableRow({children:[ new TableCell({
      width:{size:W,type:WidthType.DXA}, shading:{fill:"FFF8E6",type:ShadingType.CLEAR},
      borders:{top:bd("BA7517"),bottom:bd("BA7517"),right:bd("BA7517"),left:{style:BorderStyle.SINGLE,size:18,color:"BA7517"}},
      margins:{top:120,bottom:120,left:220,right:160},
      children:[ new Paragraph({spacing:{before:0,after:0},children:[ rb("Instructions: ",{color:"BA7517",size:18}), r(text,{color:"5A3A00",size:19}) ]}) ]
    })]})]
  });
}

function fillBox(text, height){
  return new Table({ width:{size:W,type:WidthType.DXA}, columnWidths:[W],
    rows:[new TableRow({ height:{value:height||400,rule:"atLeast"}, children:[ new TableCell({
      width:{size:W,type:WidthType.DXA}, shading:{fill:C.ghost,type:ShadingType.CLEAR},
      borders:{top:bd(),bottom:bd(),left:{style:BorderStyle.SINGLE,size:12,color:C.teal},right:bd()},
      margins:{top:160,bottom:160,left:200,right:160},
      children:[ new Paragraph({children:[ ri(text||"",{color:"BBBBBB",size:18}) ]}) ]
    })]})]
  });
}

function signoffBlock(){
  const col = Math.floor(W/2)-100;
  function side(title, l1){
    return new TableCell({ width:{size:col,type:WidthType.DXA}, borders:noBds, margins:{top:160,bottom:160,left:120,right:120}, children:[
      new Paragraph({spacing:{before:0,after:60},children:[rb(title,{color:C.blue,size:20})]}),
      new Paragraph({spacing:{before:200,after:30},border:{bottom:bd(C.steel)},children:[r(" ")]}),
      new Paragraph({spacing:{before:0,after:60},children:[ri(l1,{color:C.steel,size:18})]}),
      new Paragraph({spacing:{before:120,after:30},border:{bottom:bd(C.steel)},children:[r(" ")]}),
      new Paragraph({spacing:{before:0,after:60},children:[ri("Signature",{color:C.steel,size:18})]}),
      new Paragraph({spacing:{before:120,after:30},border:{bottom:bd(C.steel)},children:[r(" ")]}),
      new Paragraph({spacing:{before:0,after:0},children:[ri("Date",{color:C.steel,size:18})]}),
    ]});
  }
  return new Table({ width:{size:W,type:WidthType.DXA}, columnWidths:[col,200,col],
    rows:[new TableRow({children:[ side("Customer","Name and title"),
      new TableCell({width:{size:200,type:WidthType.DXA},borders:noBds,children:[new Paragraph({children:[r("")]})]}),
      side("Syncoria","OPL name and title") ]})]
  });
}

function cellFrom(cell, even){
  const mono = cell && cell.mono;
  const isB = cell && cell.b;
  const t = (cell && cell.t!==undefined) ? cell.t : (typeof cell==='string'?cell:"");
  return new TableCell({
    shading:{fill:even?C.white:C.ghost,type:ShadingType.CLEAR}, borders:bds(),
    margins:{top:80,bottom:80,left:110,right:80},
    children:[new Paragraph({children: mono?[code(t)]:[r(t,{size:18,bold:isB})]})]
  });
}

function brandedTable(headers, rows, widths){
  const cols = widths || headers.map(()=>Math.floor(W/headers.length));
  return new Table({ width:{size:W,type:WidthType.DXA}, columnWidths:cols,
    rows:[
      new TableRow({tableHeader:true, children:headers.map((h,i)=> new TableCell({
        width:{size:cols[i],type:WidthType.DXA}, shading:{fill:C.blue,type:ShadingType.CLEAR}, borders:bds(C.blue),
        margins:{top:80,bottom:80,left:110,right:80}, children:[new Paragraph({children:[rb(h,{color:C.white,size:18})]})] })) }),
      ...rows.map((row,ri2)=> new TableRow({children: row.map((cell,ci)=>{
        const c = cellFrom(cell, ri2%2===0); c.options.width={size:cols[ci],type:WidthType.DXA}; return c;
      })}))
    ]
  });
}

function build(spec){
  const children = [];
  // Cover
  children.push(coverBanner(
    "ARTIFACT  ·  " + (spec.artifactNumber||""),
    spec.artifactName||"Artifact",
    spec.subtitle||""
  ));
  children.push(sp(10));
  // Meta lines
  if (spec.meta && spec.meta.length) { metaTable(spec.meta).forEach(p=>children.push(p)); children.push(sp(6)); }
  // About box
  if (spec.aboutBox) { children.push(aboutBox(spec.aboutBox)); children.push(sp(8)); }

  // Blocks
  for (const blk of (spec.blocks||[])) {
    switch(blk.type){
      case 'section': children.push(sectionHead(blk.number||"", blk.title||"")); children.push(sp(6)); break;
      case 'subhead': children.push(subHead(blk.text||"")); break;
      case 'para': children.push(new Paragraph({spacing:{before:0,after:120},children:runsFrom(blk.runs)})); break;
      case 'instruction': children.push(instructionBox(blk.text||"")); children.push(sp(4)); break;
      case 'fill': children.push(fillBox(blk.text||"", blk.height)); children.push(sp(6)); break;
      case 'callout': children.push(calloutBox(blk.label||"", runsFrom(blk.runs||[{t:blk.text||""}]), C[blk.color]||C.blue, blk.bg||C.light)); children.push(sp(6)); break;
      case 'bullets': (blk.items||[]).forEach(it=>children.push(bul(Array.isArray(it)?runsFrom(it):[r(it)]))); break;
      case 'numbers': (blk.items||[]).forEach(it=>children.push(num(Array.isArray(it)?runsFrom(it):[r(it)]))); break;
      case 'table': children.push(brandedTable(blk.headers||[], (blk.rows||[]), blk.widths)); children.push(sp(6)); break;
      case 'space': children.push(sp(blk.pt||8)); break;
      case 'pagebreak': children.push(pb()); break;
      default: break;
    }
  }

  // Sign-off
  if (spec.signoff) {
    children.push(sp(10));
    children.push(sectionHead("\u270D", "Customer sign-off"));
    children.push(sp(8));
    children.push(signoffBlock());
  }

  return buildDoc(spec.artifactName || "Syncoria Artifact", children);
}

// ── main ──
const [,, specPath, outPath] = process.argv;
if (!specPath || !outPath) { console.error("Usage: node generate_artifact.js <spec.json> <output.docx>"); process.exit(1); }
const spec = JSON.parse(fs.readFileSync(specPath,'utf8'));
const doc = build(spec);
Packer.toBuffer(doc).then(buf=>{ fs.writeFileSync(outPath, buf); console.log("Generated: "+outPath); }).catch(e=>{console.error(e); process.exit(1);});
