using System;
using System.Security.Cryptography;
using System.Text;

namespace Launcher.Statics
{
	public class Util
	{
		internal static Util SBjLsQTQ46lo1MTWChp;

		public static string MD5Hash(string input)
		{
			StringBuilder stringBuilder = new StringBuilder();
			byte[] array = new MD5CryptoServiceProvider().ComputeHash(new UTF8Encoding().GetBytes(input));
			for (int i = 0; i < array.Length; i++)
			{
				stringBuilder.Append(array[i].ToString("x2"));
			}
			return stringBuilder.ToString();
		}

		public static string MD5(string data)
		{
			return BitConverter.ToString(smethod_0(data)).Replace("-", "").ToLower();
		}

		private static byte[] smethod_0(string string_0)
		{
			MD5CryptoServiceProvider mD5CryptoServiceProvider = new MD5CryptoServiceProvider();
			UTF8Encoding uTF8Encoding = new UTF8Encoding();
			return mD5CryptoServiceProvider.ComputeHash(uTF8Encoding.GetBytes(string_0));
		}

		public static string Base64Encode(string plainText)
		{
			return Convert.ToBase64String(Encoding.UTF8.GetBytes(plainText));
		}

		internal static bool Tnd1XOTcl14nyWim4O3()
		{
			return SBjLsQTQ46lo1MTWChp == null;
		}

		internal static void IVQltVTgifYEoVfZPKd()
		{
		}

		internal static void HoFAptTernKpbBUuVFt()
		{
		}
	}
}
