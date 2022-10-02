using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using Bussiness;

namespace Tank.Request
{
    public partial class ValidateCode : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string code = CheckCode.GenerateCheckCode();
            byte[] bytes = CheckCode.CreateImage(code);


            //System.IO.MemoryStream ms = new System.IO.MemoryStream();
            //image.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
            Response.ClearContent();
            Response.ContentType = "image/Gif";
            Response.BinaryWrite(bytes);
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            //this.CreateCheckCodeImage(Bussiness.CheckCode.GenerateCheckCode());
            this.CreateCheckCodeImage(GenerateCheckCode());
        }


        private string GenerateCheckCode()
        {
            int number;
            char code;
            string checkCode = String.Empty;

            System.Random random = new Random();

            for (int i = 0; i < 4; i++)
            {
                number = random.Next();

                //if (number % 2 == 0)
                //    code = (char)('0' + (char)(number % 10));
                //else
                code = (char)('A' + (char)(number % 26));

                checkCode += code.ToString();
            }

            //Response.Cookies.Add(new HttpCookie("CheckCode", checkCode));

            return checkCode;
        }

        public static Color[] colors = new Color[] { Color.Blue, Color.DarkRed, Color.Green, Color.Gold };

        private void CreateCheckCodeImage(string checkCode)
        {
            if (checkCode == null || checkCode.Trim() == String.Empty)
                return;



            System.Drawing.Bitmap image = new System.Drawing.Bitmap((int)Math.Ceiling((checkCode.Length * 40.5)), 44);
            Graphics g = Graphics.FromImage(image);

            try
            {
                //生成随机生成器 
                Random random = new Random();
                Color color = colors[random.Next(colors.Length)];

                //清空图片背景色 
                g.Clear(Color.Transparent);

                //画图片的背景噪音线 
                //for (int i = 0; i < 2; i++)
                //{
                //    int x1 = random.Next(image.Width);
                //    int x2 = random.Next(image.Width);
                //    int y1 = random.Next(image.Height);
                //    int y2 = random.Next(image.Height);

                //    g.DrawArc(new Pen(Color.Blue, 2), image.Width / 2, 0, image.Width, image.Height, 88, 1000);

                //    //g.DrawLine(new Pen(Color.Blue), image.Width / 4, image.Height / 4, x2, y2);
                //}
                for (int i = 0; i < 2; i++)
                {
                    int x1 = random.Next(image.Width);
                    int x2 = random.Next(image.Width);
                    int y1 = random.Next(image.Height);
                    int y2 = random.Next(image.Height);

                    g.DrawArc(new Pen(color, 2), -x1, -y1, image.Width * 2, image.Height, 45, 100);

                }

                Font font = new System.Drawing.Font("Arial", 24, (System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic));

                System.Drawing.Drawing2D.LinearGradientBrush brush = new System.Drawing.Drawing2D.LinearGradientBrush(new Rectangle(0, 0, image.Width, image.Height), color, color, 1.2f, true);
                g.DrawString(checkCode, font, brush, 2, 2);

                int angle = 40;// random.Next(80) - 40;
                double sin = Math.Sin(Math.PI * angle / 180);
                double cos = Math.Cos(Math.PI * angle / 180);
                double tan = Math.Atan(Math.PI * angle / 180);
                int px = 0;// (int)(sin * 20d);// angle / 2;
                int py = 0; //(int)(sin * 22d);// 2 - angle / 3;

                if (angle > 0)
                {
                    px = (int)(sin * 20d);// angle / 2;
                    py = (int)(-sin * image.Width);
                }
                else
                {
                    //px = 
                    py = (int)(-sin * 22d);
                }

                //g.TranslateTransform(px, 0);
                //g.RotateTransform(angle);
                //g.DrawString(checkCode[0].ToString(), font, brush, image.Width / 8, image.Width / 8*2/image.Width*py);


                TextureBrush MyBrush = new TextureBrush(image);
                MyBrush.RotateTransform(30);


                //g.TranslateTransform(px, py * 3);
                //g.DrawString(checkCode[1].ToString(), font, brush, 15, 0);

                //g.RotateTransform(-angle);

                //angle = random.Next(80) - 40;
                //px = 20 + angle / 2;
                //py = angle / 3;
                //g.RotateTransform(angle);
                //g.DrawString(checkCode[1].ToString(), font, brush, px, py);




                //g.DrawString(checkCode[0].ToString(), font, brush, 2, 2);

                //g.RotateTransform(-30f);
                //g.DrawString(checkCode[1].ToString(), font, brush, 18+6, 0);

                //g.RotateTransform(-60f);
                //g.DrawString(checkCode[1].ToString(), font, brush, 9, 27);

                //g.TranslateTransform(32, 0);
                //g.RotateTransform(120F);
                //g.DrawString(checkCode[1].ToString(), font, brush, 2, 2);


                //g1.DrawImage(image,61,44,

                //画图片的前景噪音点 
                //for (int i = 0; i < 25; i++)
                //{
                //    int x = random.Next(image.Width);
                //    int y = random.Next(image.Height);

                //    image.SetPixel(x, y, Color.FromArgb(random.Next()));
                //}

                //画图片的边框线 
                //g.DrawRectangle(new Pen(Color.Silver), 0, 0, image.Width - 1, image.Height - 1);


                //image.Save(string.Format("1.bmp"));

                //image = KiRotate(image, -45f, Color.Transparent);
                //Bitmap dst = new Bitmap((int)image.Width*2, (int)image.Height);
                //g = Graphics.FromImage(dst);
                //g.DrawImage(image, 0, 0);
                //g.DrawImage(image, image.Width, 0);

                image.Save("c:\\1.jpg", System.Drawing.Imaging.ImageFormat.Png);

                System.IO.MemoryStream ms = new System.IO.MemoryStream();
                image.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                Response.ClearContent();
                Response.ContentType = "image/Gif";
                Response.BinaryWrite(ms.ToArray());
            }
            finally
            {
                g.Dispose();
                image.Dispose();
            }
        }


        /// <summary>
        /// 任意角度旋转
        /// </summary>
        /// <param name="bmp">原始图Bitmap</param>
        /// <param name="angle">旋转角度</param>
        /// <param name="bkColor">背景色</param>
        /// <returns>输出Bitmap</returns>
        public static Bitmap KiRotate(Bitmap bmp, float angle, Color bkColor)
        {
            int w = bmp.Width + 2;
            int h = bmp.Height + 2;

            PixelFormat pf;

            if (bkColor == Color.Transparent)
            {
                pf = PixelFormat.Format32bppArgb;
            }
            else
            {
                pf = bmp.PixelFormat;
            }

            Bitmap tmp = new Bitmap(w, h, pf);
            Graphics g = Graphics.FromImage(tmp);
            g.Clear(bkColor);
            g.DrawImageUnscaled(bmp, 1, 1);
            g.Dispose();

            GraphicsPath path = new GraphicsPath();
            path.AddRectangle(new RectangleF(0f, 0f, w, h));
            Matrix mtrx = new Matrix();
            mtrx.Rotate(angle);
            RectangleF rct = path.GetBounds(mtrx);

            Bitmap dst = new Bitmap((int)rct.Width, (int)rct.Height, pf);
            g = Graphics.FromImage(dst);
            g.Clear(bkColor);
            g.TranslateTransform(-rct.X, -rct.Y);
            g.RotateTransform(angle);
            g.InterpolationMode = InterpolationMode.HighQualityBilinear;
            g.DrawImageUnscaled(tmp, 0, 0);
            g.Dispose();

            tmp.Dispose();

            return dst;
        }


    }
}
