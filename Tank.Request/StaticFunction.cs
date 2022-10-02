using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;
using System.Configuration;
using Road.Flash;
using System.IO;
using zlib;

namespace Tank.Request
{
    public class StaticFunction
    {
        public static RSACryptoServiceProvider RsaCryptor
        {
            get
            {
                string rsa = ConfigurationSettings.AppSettings["privateKey"];
                 RSACryptoServiceProvider _rsa = CryptoHelper.GetRSACrypto(rsa);
                return _rsa;
            }
        }

        #region 压缩字符串

        public static byte[] Compress(string str)
        {
            byte[] src = Encoding.UTF8.GetBytes(str);
            return Compress(src);
        }

        /// <summary>
        /// Zip compress data
        /// </summary>
        /// <param name="src"></param>
        /// <returns></returns>
        public static byte[] Compress(byte[] src)
        {
            return Compress(src, 0, src.Length);
        }

        /// <summary>
        /// Zip compress data with offset and length.
        /// </summary>
        /// <param name="src"></param>
        /// <returns></returns>
        public static byte[] Compress(byte[] src, int offset, int length)
        {
            MemoryStream ms = new MemoryStream();
            Stream s = new ZOutputStream(ms, 9);
            s.Write(src, offset, length);
            s.Close();
            return (byte[])ms.ToArray();
        }

        public static string Uncompress(string str)
        {
            byte[] src = Encoding.UTF8.GetBytes(str);
            return Encoding.UTF8.GetString(Uncompress(src));
        }

        /// <summary>
        /// Zip uncompress data.
        /// </summary>
        /// <param name="src"></param>
        /// <returns></returns>
        public static byte[] Uncompress(byte[] src)
        {
            MemoryStream md = new MemoryStream();
            Stream d = new ZOutputStream(md);
            d.Write(src, 0, src.Length);
            d.Close();
            return (byte[])md.ToArray();
        }

        #endregion
    }
}
