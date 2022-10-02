using Bussiness.CenterService;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Configuration;
using System.IO;
using System.Net;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Web.Security;

namespace Bussiness.Interface
{
    public abstract class BaseInterface
    {
        protected static readonly ILog log;

        public static string GetInterName=> ConfigurationManager.AppSettings["InterName"].ToLower();

        public static string GetLoginKey=> ConfigurationManager.AppSettings["LoginKey"];

        public static string GetChargeKey=> ConfigurationManager.AppSettings["ChargeKey"];

        public static string LoginUrl=> ConfigurationManager.AppSettings["LoginUrl"];

        public virtual int ActiveGold=> int.Parse(ConfigurationManager.AppSettings["DefaultGold"]);

        public virtual int ActiveMoney=> int.Parse(ConfigurationManager.AppSettings["DefaultMoney"]);

		#region Encrypt/Decrypt
		public static string Encrypt(string toEncrypt, string key)
		{
			bool useHashing = true;
			byte[] keyArray;
			byte[] toEncryptArray = UTF8Encoding.UTF8.GetBytes(toEncrypt);

			if (useHashing)
			{
				MD5CryptoServiceProvider hashmd5 = new MD5CryptoServiceProvider();
				keyArray = hashmd5.ComputeHash(UTF8Encoding.UTF8.GetBytes(key));
			}
			else
				keyArray = UTF8Encoding.UTF8.GetBytes(key);

			TripleDESCryptoServiceProvider tdes = new TripleDESCryptoServiceProvider();
			tdes.Key = keyArray;
			tdes.Mode = CipherMode.ECB;
			tdes.Padding = PaddingMode.PKCS7;

			ICryptoTransform cTransform = tdes.CreateEncryptor();
			byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);

			return Convert.ToBase64String(resultArray, 0, resultArray.Length);
		}
		public static string Decrypt(string toDecrypt, string key)
		{
			bool useHashing = true;
			byte[] keyArray;
			byte[] toEncryptArray = Convert.FromBase64String(toDecrypt);

			if (useHashing)
			{
				MD5CryptoServiceProvider hashmd5 = new MD5CryptoServiceProvider();
				keyArray = hashmd5.ComputeHash(UTF8Encoding.UTF8.GetBytes(key));
			}
			else
				keyArray = UTF8Encoding.UTF8.GetBytes(key);

			TripleDESCryptoServiceProvider tdes = new TripleDESCryptoServiceProvider();
			tdes.Key = keyArray;
			tdes.Mode = CipherMode.ECB;
			tdes.Padding = PaddingMode.PKCS7;

			ICryptoTransform cTransform = tdes.CreateDecryptor();
			byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);

			return UTF8Encoding.UTF8.GetString(resultArray);
		}
		#endregion
		public static string GetNameBySite(string user, string site)
        {
			if (!string.IsNullOrEmpty(site) && !string.IsNullOrEmpty(ConfigurationManager.AppSettings["LoginKey_" + site]))
			{
				user = site + "_" + user;
			}
			return user;
        }

        public static DateTime ConvertIntDateTime(double d)
        {
			return TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1)).AddSeconds(d);
        }

        public static int ConvertDateTimeInt(DateTime time)
        {
			DateTime localTime = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
			return (int)(time - localTime).TotalSeconds;
        }

        [Obsolete]
        public static string md5(string str)
        {
			return FormsAuthentication.HashPasswordForStoringInConfigFile(str, "md5").ToLower();
        }

        public static string RequestContent(string Url)
        {
			return RequestContent(Url, 2560);
        }

        public static string RequestContent(string Url, int byteLength)
        {
			byte[] numArray = new byte[byteLength];
			HttpWebRequest obj = (HttpWebRequest)WebRequest.Create(Url);
			obj.ContentType = "text/plain";
			Stream responseStream = obj.GetResponse().GetResponseStream();
			int count = responseStream.Read(numArray, 0, numArray.Length);
			string @string = Encoding.UTF8.GetString(numArray, 0, count);
			responseStream.Close();
			return @string;
        }

        public static string RequestContent(string Url, string param, string code)
        {
			Encoding encoding = Encoding.GetEncoding(code);
			byte[] bytes = encoding.GetBytes(param);
			encoding.GetString(bytes);
			byte[] numArray = new byte[2560];
			HttpWebRequest httpWebRequest = (HttpWebRequest)WebRequest.Create(Url);
			httpWebRequest.ServicePoint.Expect100Continue = false;
			httpWebRequest.Method = "POST";
			httpWebRequest.ContentType = "application/x-www-form-urlencoded";
			httpWebRequest.ContentLength = bytes.Length;
			using (Stream requestStream = httpWebRequest.GetRequestStream())
			{
				requestStream.Write(bytes, 0, bytes.Length);
			}
			using WebResponse response = httpWebRequest.GetResponse();
			int count = response.GetResponseStream().Read(numArray, 0, numArray.Length);
			return Encoding.UTF8.GetString(numArray, 0, count);
        }

        public static BaseInterface CreateInterface()
        {
			return GetInterName switch
			{
				"qunying" => new QYInterface(), 
				"sevenroad" => new SRInterface(), 
				"duowan" => new DWInterface(), 
				_ => null, 
			};
        }

        public virtual PlayerInfo CreateLogin(string name, string password, int zoneId, ref string message, ref int isFirst, string IP, ref bool isError, bool firstValidate, ref bool isActive, string site, string nickname)
        {
			try
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				bool isExist = true;
				DateTime now = DateTime.Now;
				PlayerInfo player = playerBussiness.LoginGame(name, ref isFirst, ref isExist, ref isError, firstValidate, ref now, nickname);
				if (player == null)
				{
					if (!playerBussiness.ActivePlayer(ref player, name, password, sex: true, ActiveGold, ActiveMoney, IP, site))
					{
						log.Error("cant active ActivePlayer");
						player = null;
						message = LanguageMgr.GetTranslation("BaseInterface.LoginAndUpdate.Fail");
					}
					else
					{
						isActive = true;
						using CenterServiceClient centerServiceClient2 = new CenterServiceClient();
						centerServiceClient2.ActivePlayer(isActive: true);
						log.Error("centerServiceClient2.ActivePlayer");
					}
				}
				else
				{
					if (!isExist || now > DateTime.Now)
					{
						message = LanguageMgr.GetTranslation("ManageBussiness.Forbid1", now.Year, now.Month, now.Day, now.Hour, now.Minute);
						return null;
					}
					using CenterServiceClient centerServiceClient = new CenterServiceClient();
					centerServiceClient.CreatePlayer(player.ID, name, password, isFirst == 0);
				}
				return player;
			}
			catch (Exception ex)
			{
				log.Error("LoginAndUpdate", ex);
			}
			return null;
        }

        public virtual PlayerInfo LoginGame(string name, string pass, int zoneId, ref bool isFirst)
        {
			try
			{
				using CenterServiceClient centerServiceClient = new CenterServiceClient();
				int userID = 0;
				if (centerServiceClient.ValidateLoginAndGetID(name, pass, zoneId, ref userID, ref isFirst))
				{
					return new PlayerInfo
					{
						ID = userID,
						UserName = name
					};
				}
			}
			catch (Exception ex)
			{
				log.Error("LoginGame", ex);
			}
			return null;
        }

        [Obsolete]
        public virtual string[] UnEncryptLogin(string content, ref int result, string site)
        {
			try
			{
				string str = string.Empty;
				if (!string.IsNullOrEmpty(site))
				{
					str = ConfigurationManager.AppSettings["LoginKey_" + site];
				}
				if (string.IsNullOrEmpty(str))
				{
					str = GetLoginKey;
				}
				if (!string.IsNullOrEmpty(str))
				{
					string[] strArray = content.Split('|');
					if (strArray.Length > 3)
					{
						if (md5(strArray[0] + strArray[1] + strArray[2] + str) == strArray[3].ToLower())
						{
							return strArray;
						}
						result = 5;
					}
					else
					{
						result = 2;
					}
				}
				else
				{
					result = 4;
				}
			}
			catch (Exception ex)
			{
				log.Error("UnEncryptLogin", ex);
			}
			return new string[0];
        }

        [Obsolete]
        public virtual string[] UnEncryptCharge(string content, ref int result, string site)
        {
			try
			{
				string str1 = string.Empty;
				if (!string.IsNullOrEmpty(site))
				{
					str1 = ConfigurationManager.AppSettings["ChargeKey_" + site];
				}
				if (string.IsNullOrEmpty(str1))
				{
					str1 = GetChargeKey;
				}
				if (!string.IsNullOrEmpty(str1))
				{
					string[] strArray = content.Split('|');
					string str2 = md5(strArray[0] + strArray[1] + strArray[2] + strArray[3] + strArray[4] + str1);
					if (strArray.Length > 5)
					{
						if (str2 == strArray[5].ToLower())
						{
							return strArray;
						}
						result = 7;
					}
					else
					{
						result = 8;
					}
				}
				else
				{
					result = 6;
				}
			}
			catch (Exception ex)
			{
				log.Error("UnEncryptCharge", ex);
			}
			return new string[0];
        }

        [Obsolete]
        public virtual string[] UnEncryptSentReward(string content, ref int result, string key)
        {
			try
			{
				string[] strArray = content.Split('#');
				if (strArray.Length == 8)
				{
					string appSetting = ConfigurationManager.AppSettings["SentRewardTimeSpan"];
					int num = int.Parse(string.IsNullOrEmpty(appSetting) ? "1" : appSetting);
					TimeSpan timeSpan = (string.IsNullOrEmpty(strArray[6]) ? new TimeSpan(1, 1, 1) : (DateTime.Now - ConvertIntDateTime(double.Parse(strArray[6]))));
					if (timeSpan.Days == 0 && timeSpan.Hours == 0 && timeSpan.Minutes < num)
					{
						if (string.IsNullOrEmpty(key))
						{
							return strArray;
						}
						if (md5(strArray[2] + strArray[3] + strArray[4] + strArray[5] + strArray[6] + key) == strArray[7].ToLower())
						{
							return strArray;
						}
						result = 5;
					}
					else
					{
						result = 7;
					}
				}
				else
				{
					result = 6;
				}
			}
			catch (Exception ex)
			{
				log.Error("UnEncryptSentReward", ex);
			}
			return new string[0];
        }

        public virtual bool GetUserSex(string name)
        {
			return true;
        }

        public static bool CheckRnd(string str)
        {
			return !string.IsNullOrEmpty(str);
        }

        static BaseInterface()
        {
			log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }
    }
}
