using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Tank.Flash.auth
{
    /// <summary>
    /// Summary description for forgotpass1
    /// </summary>
    public class forgotpass1 : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string message = "Request False!";
            
            context.Response.Write(message);
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