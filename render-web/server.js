const express = require("express");
const helmet = require("helmet");
const rateLimit = require("express-rate-limit");
const { Pool } = require("pg");
const crypto = require("node:crypto");

const app = express();
app.disable("x-powered-by");
app.set("trust proxy", 1);
app.use(helmet({ contentSecurityPolicy: false }));
app.use(express.urlencoded({ extended: false, limit: "10kb" }));
app.use(express.json({ limit: "10kb" }));
const pool = new Pool({ connectionString: process.env.DATABASE_URL, ssl: process.env.NODE_ENV === "production" ? { rejectUnauthorized: false } : undefined });
const PORT = Number(process.env.PORT || 10000);
const lifetime = 7 * 24 * 60 * 60 * 1000;
const sha = (s) => crypto.createHash("sha256").update(s).digest("hex");
const makePassword = (p, salt = crypto.randomBytes(16).toString("hex")) =>
  new Promise((resolve, reject) => crypto.scrypt(p, salt, 64, (err, key) =>
    err ? reject(err) : resolve(salt + ":" + key.toString("hex"))));
async function verifyPassword(p, stored) {
  const [salt, hash] = (stored || "").split(":");
  if (!salt || !hash || hash.length !== 128) return false;
  const other = (await makePassword(p, salt)).split(":")[1];
  return crypto.timingSafeEqual(Buffer.from(hash, "hex"), Buffer.from(other, "hex"));
}
const esc = (x) => String(x ?? "").replace(/[&<>"']/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
function page(title, body, user) {
  return `<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>${esc(title)} | DDTank Portal</title><style>
  :root{color-scheme:dark}*{box-sizing:border-box}body{margin:0;font-family:system-ui,Arial;background:radial-gradient(ellipse at 10% 0%,#243b75,#0a1124 65%);color:#ecf4ff;min-height:100vh}header{padding:20px max(18px,calc((100vw - 1040px)/2));display:flex;align-items:center;justify-content:space-between;background:#081124bb;border-bottom:1px solid #334b7a}a{color:#8edbff;text-decoration:none}nav{display:flex;align-items:center;gap:14px;flex-wrap:wrap}.brand{font-weight:900;letter-spacing:1px;font-size:23px;color:#fff}main{max-width:1040px;margin:42px auto;padding:0 18px}.panel{background:#101f3bde;border:1px solid #355180;border-radius:19px;padding:28px;box-shadow:0 16px 40px #05091955;margin-bottom:20px}h1{font-size:clamp(28px,4vw,43px);margin:0 0 12px}h2{margin-top:0}p{line-height:1.6;color:#c6d7ee}.muted{color:#91abc9}input{display:block;width:100%;padding:13px 14px;margin:8px 0 15px;background:#08142a;border:1px solid #41618e;border-radius:9px;color:white}label{display:block;font-weight:600}button,.btn{display:inline-block;padding:12px 18px;border-radius:10px;border:0;background:#279eff;color:#06132b;font-weight:800;cursor:pointer}button:hover,.btn:hover{background:#80cbff}.outline{background:#273c62;color:white}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(210px,1fr));gap:16px}.chip{padding:9px 13px;background:#173357;border:1px solid #426093;border-radius:10px;display:inline-block}.warn{color:#ffc971}.success{color:#80e4b6}.error{color:#ff9ea8}.tablewrap{overflow:auto}table{width:100%;border-collapse:collapse}td,th{border-bottom:1px solid #344a6d;padding:12px;text-align:left}footer{padding:26px;text-align:center;color:#8198b6;font-size:13px}form.inline{display:inline}form.inline button{background:#273c62;color:#fff;padding:8px 12px}</style></head><body><header><a href="/" class="brand">🎯 DDTank Portal</a><nav><a href="/">Início</a>${user ? '<a href="/dashboard">Painel</a>'+(user.role === "admin" ? '<a href="/admin">Admin</a>' : '')+'<form class="inline" method="POST" action="/logout"><button>Sair</button></form>' : '<a href="/login">Entrar</a><a href="/register">Cadastrar</a>'}</nav></header><main>${body}</main><footer>Portal independente de desenvolvimento • O servidor multiplayer ainda não está integrado.</footer></body></html>`;
}
function send(res, title, body, user, status=200) { res.status(status).type("html").send(page(title, body, user)); }
function cookie(req, name) { const v=(req.headers.cookie || "").split(";").map(x=>x.trim()).find(x=>x.startsWith(name+"=")); return v ? v.slice(name.length+1) : ""; }
const cookieOptions={ httpOnly:true, sameSite:"lax", secure:process.env.NODE_ENV==="production", path:"/", maxAge:lifetime };
app.use(async (req,res,next)=>{
  try {
    const token=cookie(req,"ddtank_session");
    if (!/^[a-f0-9]{64}$/.test(token)) return next();
    const found=await pool.query("SELECT u.id,u.email,u.role FROM portal_sessions s JOIN portal_users u ON u.id=s.user_id WHERE s.token_hash=$1 AND s.expires_at>NOW()",[sha(token)]);
    req.user=found.rows[0] || null; return next();
  } catch(err) { return next(err); }
});
const throttler=rateLimit({windowMs:15*60*1000,limit:30,standardHeaders:"draft-7",legacyHeaders:false});
function requireUser(req,res,next){if(!req.user)return res.redirect("/login");next()}
function requireAdmin(req,res,next){if(!req.user)return res.redirect("/login");if(req.user.role!=="admin")return send(res,"Acesso negado",'<section class="panel"><h1>Acesso negado</h1></section>',req.user,403);next()}
function sameOrigin(req,res,next){const origin=req.get("origin"); if(origin){try {const target=new URL(origin);if(target.host!==req.get("host") || target.protocol!=="https:" && process.env.NODE_ENV==="production") return res.status(403).send("Origem inválida");}catch{return res.status(403).send("Origem inválida")}}next()}
app.use((req,res,next)=> req.method==="POST" ? sameOrigin(req,res,next):next());
app.get("/health",async(req,res)=>{try{await pool.query("SELECT 1");res.json({status:"ok",database:"connected",gameServer:"not-integrated"})}catch{res.status(503).json({status:"unavailable"})}});
app.get("/", (req,res)=>send(res,"Início",'<section class="panel"><span class="chip">Projeto DDTank41 • Fase 1</span><h1>Seu novo portal DDTank</h1><p>Cadastro, autenticação e gerenciamento inicial de usuários do portal. O servidor clássico, batalhas, moedas e itens ainda não estão conectados.</p><a class="btn" href="'+(req.user?'/dashboard':'/register')+'">Acessar portal</a></section><div class="grid"><section class="panel"><h2>👤 Contas</h2><p>Cadastre e gerencie usuários do portal.</p></section><section class="panel"><h2>🛡️ Administração</h2><p>Visualize contas com acesso restrito.</p></section><section class="panel"><h2>🎮 Multiplayer</h2><p class="warn">Aguardando migração do servidor legado.</p></section></div>',req.user));
app.get("/register",(req,res)=>send(res,"Cadastrar",'<section class="panel" style="max-width:490px;margin:auto"><h1>Crie sua conta</h1><form method="post"><label>E-mail<input type="email" name="email" required maxlength="254" autocomplete="email"></label><label>Senha (mínimo de 12 caracteres)<input type="password" name="password" required minlength="12" maxlength="128" autocomplete="new-password"></label><button>Cadastrar</button></form><p class="muted">Esta conta é apenas do portal, não do servidor do jogo.</p></section>',req.user));
app.post("/register",throttler,async(req,res,next)=>{try{
  const email=String(req.body.email||"").trim().toLowerCase(), password=String(req.body.password||"");
  if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)||email.length>254||password.length<12||password.length>128)return send(res,"Dados inválidos",'<section class="panel"><p class="error">E-mail ou senha inválidos.</p><a href="/register">Voltar</a></section>',null,400);
  await pool.query("INSERT INTO portal_users(email,password_hash,role) VALUES ($1,$2,'player')",[email,await makePassword(password)]);
  res.redirect("/login?created=1");
}catch(err){if(err.code==="23505")return send(res,"Conta existente",'<section class="panel"><p>Este e-mail já está cadastrado.</p><a href="/login">Entrar</a></section>',null,409);next(err)}});
app.get("/login",(req,res)=>send(res,"Entrar",'<section class="panel" style="max-width:490px;margin:auto"><h1>Entrar</h1>'+(req.query.created?'<p class="success">Conta criada. Faça login.</p>':'')+'<form method="post"><label>E-mail<input type="email" name="email" required autocomplete="email"></label><label>Senha<input type="password" name="password" required autocomplete="current-password"></label><button>Entrar</button></form></section>',req.user));
app.post("/login",throttler,async(req,res,next)=>{try{
 const email=String(req.body.email||"").trim().toLowerCase(),pass=String(req.body.password||"");
 if(email.length>254||pass.length>128)return res.status(400).send("Dados inválidos");
 const r=await pool.query("SELECT * FROM portal_users WHERE email=$1",[email]);
 if(!r.rowCount||!await verifyPassword(pass,r.rows[0].password_hash))return send(res,"Falha",'<section class="panel"><p class="error">Credenciais inválidas.</p><a href="/login">Tentar novamente</a></section>',null,401);
 const token=crypto.randomBytes(32).toString("hex");await pool.query("INSERT INTO portal_sessions(user_id,token_hash,expires_at) VALUES($1,$2,NOW()+INTERVAL '7 days')",[r.rows[0].id,sha(token)]);
 res.cookie("ddtank_session",token,cookieOptions);res.redirect("/dashboard");
}catch(err){next(err)}});
app.post("/logout",async(req,res,next)=>{try{const token=cookie(req,"ddtank_session");if(token)await pool.query("DELETE FROM portal_sessions WHERE token_hash=$1",[sha(token)]);res.clearCookie("ddtank_session",{path:"/"});res.redirect("/")}catch(e){next(e)}});
app.get("/dashboard",requireUser,(req,res)=>send(res,"Painel",'<section class="panel"><h1>Olá, '+esc(req.user.email)+'</h1><p>Conta do portal ativa.</p><div class="chip">Jogo: <strong class="warn">não integrado</strong></div><p>Itens, personagens e partidas serão exibidos após a migração do backend original.</p></section>',req.user));
app.get("/admin",requireAdmin,async(req,res,next)=>{try{
 const result=await pool.query("SELECT id,email,role,created_at FROM portal_users ORDER BY created_at DESC LIMIT 200");
 const rows=result.rows.map(u=>'<tr><td>'+u.id+'</td><td>'+esc(u.email)+'</td><td>'+esc(u.role)+'</td><td>'+esc(new Date(u.created_at).toLocaleString("pt-BR",{timeZone:"America/Sao_Paulo"}))+'</td></tr>').join("");
 send(res,"Admin",'<section class="panel"><h1>Administração</h1><p>Contas cadastradas no portal (até 200 mais recentes). Não são contas do jogo original.</p><div class="tablewrap"><table><thead><tr><th>ID</th><th>E-mail</th><th>Papel</th><th>Cadastro</th></tr></thead><tbody>'+rows+'</tbody></table></div></section>',req.user);
}catch(err){next(err)}});
app.use((err,req,res,next)=>{console.error("Request failed:",err.code||err.name||"error");if(res.headersSent)return next(err);send(res,"Erro",'<section class="panel"><h1>Erro interno</h1><p>Tente novamente.</p></section>',req.user,500)});
async function bootstrap(){
 if(!process.env.DATABASE_URL)throw Error("DATABASE_URL não configurada");
 await pool.query(`CREATE TABLE IF NOT EXISTS portal_users(id BIGSERIAL PRIMARY KEY,email TEXT NOT NULL UNIQUE,password_hash TEXT NOT NULL,role TEXT NOT NULL DEFAULT 'player' CHECK(role IN('player','admin')),created_at TIMESTAMPTZ NOT NULL DEFAULT NOW())`);
 await pool.query(`CREATE TABLE IF NOT EXISTS portal_sessions(token_hash TEXT PRIMARY KEY,user_id BIGINT NOT NULL REFERENCES portal_users(id) ON DELETE CASCADE,expires_at TIMESTAMPTZ NOT NULL)`);
 const email=(process.env.ADMIN_EMAIL||"").trim().toLowerCase(),password=process.env.ADMIN_PASSWORD||"";
 if(email && password.length>=12){
  const r=await pool.query("SELECT 1 FROM portal_users WHERE email=$1",[email]);
  if(!r.rowCount){await pool.query("INSERT INTO portal_users(email,password_hash,role) VALUES($1,$2,'admin')",[email,await makePassword(password)]);console.log("Initial admin created")}
 } else console.warn("ADMIN_EMAIL/ADMIN_PASSWORD ausentes ou inválidos; administrador não provisionado");
 app.listen(PORT,"0.0.0.0",()=>console.log("DDTank web portal listening on "+PORT));
}
bootstrap().catch(e=>{console.error("Startup failed:",e.message);process.exit(1)});
