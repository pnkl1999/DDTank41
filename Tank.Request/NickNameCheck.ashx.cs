using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using SqlDataProvider.Data;
using Bussiness;
using log4net;
using System.Reflection;
using System.Configuration;
using System.Text.RegularExpressions;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class NickNameCheck : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            string path = HttpContext.Current.Server.MapPath(".");
            path += "\\";
            LanguageMgr.Setup(path);
            bool value = false;
            //string message = "Name is Exist!";
            //string message = LanguageMgr.GetTranslation("Tank.Request.NickNameCheck.Exist");
            string message = LanguageMgr.GetTranslation(" Tên người chơi đã tồn tại");
            XElement result = new XElement("Result");

            try
            {
                string nickName = csFunction.ConvertSql(HttpUtility.UrlDecode(context.Request["NickName"]));
                if (System.Text.Encoding.Default.GetByteCount(nickName) <= 14)
                {
                    if (!string.IsNullOrEmpty(nickName))
                    {
                        var regexItem = new Regex("^[a-za-z0-9àáâãèéêìíòóôõùúăđĩũơàáâãèéêìíòóôõùúăđĩũơưăạảấầẩẫậắằẳẵặẹẻẽềềểếưăạảấầẩẫậắằẳẵặẹẻẽềềểếễệỉịọỏốồổỗộớờởỡợụủứừễệỉịọỏốồổỗộớờởỡợụủứừửữựỳỵýỷỹửữựỳỵỷỹ\\s|_.]+$");
                        if (!regexItem.IsMatch(nickName))
                        //string specialCharacters = @"%!@#$%^&*()?/>.<,:;'\|}]{[_~`+=-" + "\"";
                        //char[] specialCharactersArray = specialCharacters.ToCharArray();

                        //if (nickName.IndexOfAny(specialCharactersArray) != -1)
                        {
                            message = LanguageMgr.GetTranslation("UseReworkNameHandler.HasSpecialCharacters");
                        }
                        else
                        {
                            using (PlayerBussiness db = new PlayerBussiness())
                            {
                                if (db.GetUserSingleByNickName(nickName) == null)
                                {
                                    value = true;
                                    //message = "You can register!";
                                    message = LanguageMgr.GetTranslation("Tank.Request.NickNameCheck.Right");

                                }
                            }
                        }
                    }
                }
                else
                {
                    message = LanguageMgr.GetTranslation("Tank.Request.NickNameCheck.Long");
                }
            }
            catch (Exception ex)
            {
                log.Error("NickNameCheck", ex);
                value = false;
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            context.Response.ContentType = "text/plain";
            context.Response.Write(result.ToString(false));
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
