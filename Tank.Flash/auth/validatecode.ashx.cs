using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Bussiness;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Web.SessionState;

namespace Tank.Flash.auth
{
    /// <summary>
    /// Summary description for validatecode
    /// </summary>
    public class validatecode : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string code = CheckCode.GenerateCheckCode();
            byte[] bytes = CheckCode.CreateImage(code);
            context.Session["CheckCode"] = code;
            context.Response.ClearContent();
            context.Response.ContentType = "image/Gif";
            context.Response.BinaryWrite(bytes);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}