using System;
using System.Collections;
using System.Collections.Specialized;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Reflection;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using Launcher.Properties;
using Properties;
using zlib;

namespace Launcher.Statics
{
	public class ControlMgr
	{
		public const string ErrorCon = "Kết nối internet thất bại! Vui lòng kiễm trả đường truyền!";

		internal static ControlMgr NA57R9krsIpJiLyU0Ph;

		public static ArrayList GetResourceString(string scriptFile)
		{
			StreamReader streamReader = new StreamReader(Assembly.GetExecutingAssembly().GetManifestResourceStream(scriptFile), Encoding.UTF8);
			ArrayList arrayList = new ArrayList();
			string value;
			while ((value = streamReader.ReadLine()) != null)
			{
				arrayList.Add(value);
			}
			return arrayList;
		}

		public static void OpenWebsite(string url)
		{
			Process process = new Process();
			try
			{
				process.StartInfo.UseShellExecute = true;
				process.StartInfo.FileName = url;
				process.Start();
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception 8 " + ex.Message, ex.ToString());
			}
		}

		public static string Request(string url, string para)
		{
			try
			{
				ServicePointManager.ServerCertificateValidationCallback = (RemoteCertificateValidationCallback)Delegate.Combine(ServicePointManager.ServerCertificateValidationCallback, (RemoteCertificateValidationCallback)((object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) => true));
				ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls | (SecurityProtocolType)0xc00;
			}
			catch
			{
			}
			byte[] bytes = Encoding.UTF8.GetBytes(para);
			WebRequest webRequest = WebRequest.Create(new Uri(url));
			webRequest.Method = "POST";
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.ContentLength = bytes.Length;
			webRequest.Credentials = CredentialCache.DefaultCredentials;
			using (Stream stream = webRequest.GetRequestStream())
			{
				stream.Write(bytes, 0, bytes.Length);
			}
			using WebResponse webResponse = webRequest.GetResponse();
			using Stream stream2 = webResponse.GetResponseStream();
			return new StreamReader(stream2, Encoding.UTF8).ReadToEnd();
		}

		public static string PostString(string url, string param, string method = "POST")
		{
			try
			{
				try
				{
					ServicePointManager.ServerCertificateValidationCallback = (RemoteCertificateValidationCallback)Delegate.Combine(ServicePointManager.ServerCertificateValidationCallback, (RemoteCertificateValidationCallback)((object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) => true));
					ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls | (SecurityProtocolType)0xc00;
				}
				catch
				{
				}
				using WebClient webClient = new WebClient();
				webClient.Headers[HttpRequestHeader.CacheControl] = "no-cache";
				webClient.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
				webClient.Headers[HttpRequestHeader.Accept] = "text/html, application/xhtml+xml, */*";
				webClient.Headers[HttpRequestHeader.UserAgent] = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)";
				webClient.Encoding = Encoding.UTF8;
				webClient.Credentials = CredentialCache.DefaultCredentials;
				return webClient.UploadString(url, method, param);
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception 9 " + ex.Message, ex.ToString());
				return ex.Message;
			}
		}

		public static string Post(string url, NameValueCollection param, string method = "POST")
		{
			try
			{
				try
				{
					ServicePointManager.ServerCertificateValidationCallback = (RemoteCertificateValidationCallback)Delegate.Combine(ServicePointManager.ServerCertificateValidationCallback, (RemoteCertificateValidationCallback)((object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) => true));
					ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls | (SecurityProtocolType)0xc00;
				}
				catch
				{
				}
				using WebClient webClient = new WebClient();
				webClient.Headers[HttpRequestHeader.CacheControl] = "no-cache";
				webClient.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
				webClient.Headers[HttpRequestHeader.Accept] = "text/html, application/xhtml+xml, */*";
				webClient.Headers[HttpRequestHeader.UserAgent] = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)";
				webClient.Encoding = Encoding.UTF8;
				webClient.Credentials = CredentialCache.DefaultCredentials;
				byte[] byte_ = webClient.UploadValues(url, method, param);
				return Encoding.UTF8.GetString(byte_);
				//return Encoding.UTF8.GetString(IyjymQihFO(byte_));
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception 10 " + ex.Message, ex.ToString());
				return "Kết nối máy chủ thất bại. (109061)";
			}
		}

		public static byte[] CryptData(string data)
		{
			byte[] bytes = Encoding.UTF8.GetBytes(data);
			return bytes;
			return smethod_1(smethod_0(Encoding.UTF8.GetBytes(Resources.PublicKey), bytes));
		}

		private static byte[] IyjymQihFO(byte[] byte_0)
		{
			byte[] array = byte_0;
			try
			{
				array = Pgkybonssj(byte_0);
			}
			catch
			{
				return array;
			}
			return smethod_0(Encoding.UTF8.GetBytes(Resources.PublicKey), array);
		}

		private static byte[] smethod_0(object object_0, byte[] byte_0)
		{
			for (int i = 0; i < byte_0.Length; i++)
			{
				byte_0[i] = (byte)(byte_0[i] ^ ((byte[])object_0)[i % ((Array)object_0).Length]);
			}
			return byte_0;
		}

		private static byte[] smethod_1(byte[] byte_0)
		{
			return smethod_2(byte_0, 0, byte_0.Length);
		}

		private static byte[] smethod_2(byte[] byte_0, int int_0, int int_1)
		{
			//IL_0008: Unknown result type (might be due to invalid IL or missing references)
			//IL_000d: Unknown result type (might be due to invalid IL or missing references)
			//IL_0016: Expected O, but got Unknown
			//IL_001b: Expected O, but got Unknown
			MemoryStream memoryStream = new MemoryStream();
			ZOutputStream val = new ZOutputStream((Stream)memoryStream, 9);
			((Stream)val).Write(byte_0, int_0, int_1);
			((Stream)val).Close();
			return memoryStream.ToArray();
		}

		private static byte[] Pgkybonssj(byte[] byte_0)
		{
			//IL_0006: Unknown result type (might be due to invalid IL or missing references)
			//IL_000b: Unknown result type (might be due to invalid IL or missing references)
			//IL_0016: Expected O, but got Unknown
			//IL_001b: Expected O, but got Unknown
			MemoryStream memoryStream = new MemoryStream();
			ZOutputStream val = new ZOutputStream((Stream)memoryStream);
			((Stream)val).Write(byte_0, 0, byte_0.Length);
			((Stream)val).Close();
			return memoryStream.ToArray();
		}

		public static string Get(string url, string param = "")
		{
			try
			{
				try
				{
					ServicePointManager.ServerCertificateValidationCallback = (RemoteCertificateValidationCallback)Delegate.Combine(ServicePointManager.ServerCertificateValidationCallback, (RemoteCertificateValidationCallback)((object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) => true));
					ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls | (SecurityProtocolType)0xc00;
				}
				catch
				{
				}
				using WebClient webClient = new WebClient();
				webClient.Headers[HttpRequestHeader.CacheControl] = "no-cache";
				webClient.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
				webClient.Headers[HttpRequestHeader.Accept] = "text/html, application/xhtml+xml, */*";
				webClient.Headers[HttpRequestHeader.UserAgent] = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)";
				webClient.Encoding = Encoding.UTF8;
				webClient.Credentials = CredentialCache.DefaultCredentials;
				return webClient.UploadString(url, param);
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception 11 " + ex.Message, ex.ToString());
				return "";
			}
		}

		internal static bool qWLxdvkIYX8LUAZcENo()
		{
			return NA57R9krsIpJiLyU0Ph == null;
		}

		internal static void Wpdrj2kYW5etXAyNG25()
		{
		}
	}
}
