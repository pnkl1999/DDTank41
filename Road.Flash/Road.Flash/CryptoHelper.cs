using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;

namespace Road.Flash
{
    public class CryptoHelper
    {
        public static RSACryptoServiceProvider GetRSACrypto(string privateKey)
        {
            CspParameters csp = new CspParameters();
            csp.Flags = CspProviderFlags.UseMachineKeyStore;
            RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(csp);
            rsa.FromXmlString(privateKey);
            return rsa;
        }

        /// <summary>
        ///  用RSA解密基于Base64编码的字符串，返回UTF-8编码的字符串
        /// </summary>
        /// <param name="privateKey"></param>
        /// <param name="src"></param>
        /// <returns></returns>
        public static string RsaDecrypt(string privateKey, string src)
        {
            CspParameters csp = new CspParameters();
            csp.Flags = CspProviderFlags.UseMachineKeyStore;
            RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(csp);
            rsa.FromXmlString(privateKey);
            return RsaDecrypt(rsa, src);
        }
        public static string RsaDecrypt(RSACryptoServiceProvider rsa, string src)
        {
            byte[] srcData = Convert.FromBase64String(src);
            byte[] destData = rsa.Decrypt(srcData, false);
            return Encoding.UTF8.GetString(destData);
        }

        public static byte[] StringToByteArray(string hex)
        {
            int NumberChars = hex.Length;
            byte[] bytes = new byte[NumberChars / 2];
            for (int i = 0; i < NumberChars; i += 2)
            {
                bytes[i / 2] = Convert.ToByte(hex.Substring(i, 2), 0x10);
            }
            return bytes;
        }
        public static string ByteArrayToString(byte[] ba)
        {
            StringBuilder hex = new StringBuilder(ba.Length * 2);
            for (int i = 0; i < ba.Length; i++)
            {
                hex.Append(ba[i].ToString("X2"));
            }
            return hex.ToString();
        }
        public static byte[] RsaDecryt2(RSACryptoServiceProvider rsa, string src)
        {
            byte[] srcData = Convert.FromBase64String(src);
            return rsa.Decrypt(srcData, false);
        }
        public static byte[] RsaDecryt3(RSACryptoServiceProvider rsa, string src)
        {
            byte[] srcData = Convert.FromBase64String(src);
            return rsa.Decrypt(srcData, false);
        }
        public static string TripleDesDecrypt(string privateKey, string iv, string cypherText)
        {
            byte[] keyArray = StringToByteArray(privateKey);
            byte[] toDecryptArray = StringToByteArray(cypherText);
            TripleDESCryptoServiceProvider initLocal0 = new TripleDESCryptoServiceProvider
            {
                Key = keyArray,
                Mode = CipherMode.CBC,
                Padding = PaddingMode.Zeros,
                IV = StringToByteArray(iv)
            };
            TripleDESCryptoServiceProvider tdes = initLocal0;
            byte[] resultArray = tdes.CreateDecryptor().TransformFinalBlock(toDecryptArray, 0, toDecryptArray.Length);
            return Encoding.UTF8.GetString(resultArray).Replace('\0', ' ').Trim();
        }

        public static string TripleDesEncrypt(string privateKey, string plainText, ref string iv)
        {
            byte[] keyArray = StringToByteArray(privateKey);
            byte[] toEncryptArray = Encoding.UTF8.GetBytes(plainText);
            TripleDESCryptoServiceProvider initLocal1 = new TripleDESCryptoServiceProvider
            {
                Key = keyArray,
                Mode = CipherMode.CBC,
                Padding = PaddingMode.Zeros
            };
            TripleDESCryptoServiceProvider tdes = initLocal1;
            if ((iv != null) && (iv.Length == 0x10))
            {
                tdes.IV = StringToByteArray(iv);
            }
            string cypherText = ByteArrayToString(tdes.CreateEncryptor().TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length));
            if (iv != null)
            {
                iv = ByteArrayToString(tdes.IV);
            }
            return cypherText;
        }
    }
}
