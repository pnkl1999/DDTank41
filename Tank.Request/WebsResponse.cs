using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
namespace Tank.Request
{
    public class WebsResponse
    {
        /// <summary>
        /// 模拟提交
        /// </summary>
        /// <param name="url">请求地址</param>
        /// <param name="postData">提交数数</param>
        /// <param name="encodeType">页面编码</param>
        /// <param name="err">返回错误信息</param>
        /// <returns>返回结果</returns>
        public static string GetPage(string url, string postData, string encodeType, out string err)
        {

            Stream outstream = null;

            Stream instream = null;

            StreamReader sr = null;

            HttpWebResponse response = null;

            HttpWebRequest request = null;

            Encoding encoding = Encoding.GetEncoding(encodeType);

            byte[] data = encoding.GetBytes(postData);

            // 准备请求... 

            try
            {

                // 设置参数 

                request = WebRequest.Create(url) as HttpWebRequest;

                CookieContainer cookieContainer = new CookieContainer();

                request.CookieContainer = cookieContainer;

                request.AllowAutoRedirect = true;

                request.Method = "POST";

                request.ContentType = "application/x-www-form-urlencoded";

                request.ContentLength = data.Length;

                outstream = request.GetRequestStream();

                outstream.Write(data, 0, data.Length);

                outstream.Close();

                //发送请求并获取相应回应数据 

                response = request.GetResponse() as HttpWebResponse;

                //直到request.GetResponse()程序才开始向目标网页发送Post请求 

                instream = response.GetResponseStream();

                sr = new StreamReader(instream, encoding);

                //返回结果网页（html）代码 

                string content = sr.ReadToEnd();

                err = string.Empty;

                return content;

            }

            catch (Exception ex)
            {

                err = ex.Message;

                return string.Empty;

            }

        }
    }
}
