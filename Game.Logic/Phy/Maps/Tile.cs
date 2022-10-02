using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.IO;

namespace Game.Logic.Phy.Maps
{
    public class Tile
    {
        private byte[] _data;

        private int _width;

        private int _height;

        private Rectangle _rect;


        public Rectangle Bound
        {
            get
            {
                return _rect;
            }
        }

        public byte[] Data
        {
            get { return _data; }
        }

        public int Width
        {
            get { return _width; }
        }

        public int Height
        {
            get { return _height; }
        }

        private int _bw = 0;

        private int _bh = 0;

        private bool _digable;

        public Tile(byte[] data, int width, int height, bool digable)
        {
            _data = data;

            _width = width;
            _height = height;
            _digable = digable;

            _bw = _width / 8 + 1;
            _bh = _height;

            _rect = new Rectangle(0, 0, _width, _height);
            GC.AddMemoryPressure(data.Length);
        }


        public Tile(Bitmap bitmap, bool digable)
        {
            _width = bitmap.Width;
            _height = bitmap.Height;
            _bw = _width / 8 + 1;
            _bh = _height;
            _data = new byte[_bw * _bh];
            _digable = digable;

            for (int j = 0; j < bitmap.Height; j++)
            {
                for (int i = 0; i < bitmap.Width; i++)
                {
                    byte flag = (byte)(bitmap.GetPixel(i, j).A <= 100 ? 0 : 1);

                    _data[j * _bw + i / 8] |= (byte)(flag << (7 - i % 8));
                }
            }

            _rect = new Rectangle(0, 0, _width, _height);
            GC.AddMemoryPressure(_data.Length);
        }

        public Tile(string file, bool digable)
        {
            FileStream fs = File.Open(file, FileMode.Open);
            BinaryReader reader = new BinaryReader(fs);

            _width = reader.ReadInt32();
            _height = reader.ReadInt32();
            _bw = _width / 8 + 1;
            _bh = _height;
            _data = reader.ReadBytes(_bw * _bh);
            _digable = digable;
            _rect = new Rectangle(0, 0, _width, _height);

            reader.Close();
            GC.AddMemoryPressure(_data.Length);
        }



        public void Dig(int cx, int cy, Tile surface, Tile border)
        {
            if (_digable && surface != null)
            {
                int x1 = (int)(cx - surface.Width / 2);
                int y1 = (int)(cy - surface.Height / 2);

                Remove(x1, y1, surface);

                if (border != null)
                {
                    x1 = (int)(cx - border.Width / 2);
                    y1 = (int)(cy - border.Height / 2);

                    Add(x1, y1, surface);
                }
            }
        }

        protected void Add(int x, int y, Tile tile)
        {
            //需要重写，原来的逻辑不对，参照Remove

            //
            //byte[] addData = tile._data;

            //Rectangle rect = tile.Bound;

            //rect.Offset(x, y);
            //rect.Intersect(_rect);
            //if (rect.Width != 0 && rect.Height != 0)
            //{
            //    rect.Offset(-x, -y);

            //    int cx = rect.X / 8;
            //    int cx2 = (rect.X + x) / 8;

            //    int cy = rect.Y;
            //    int cw = (int)Math.Floor((double)rect.Width / 8);
            //    int ch = rect.Height;

            //    int b_offset = rect.X % 8;

            //    int self_offset = 0;
            //    int tile_offset = 0;

            //    Int32 r_bits = 0;
            //    Int32 l_bits = 0;

            //    int src = 0;
            //    int target = 0;
            //    for (int j = 0; j < ch; j++)
            //    {
            //        r_bits = 0;
            //        l_bits = 0;
            //        for (int i = 0; i < cw; i++)
            //        {
            //            self_offset = (j + y + cy) * _bw + i + cx2;
            //            tile_offset = (j + cy) * tile._bw + i + cx;

            //            src = addData[tile_offset];

            //            r_bits = src >> b_offset;

            //            _data[self_offset] |= (byte)r_bits;
            //            _data[self_offset] |= (byte)l_bits;

            //            l_bits = src << 8 - b_offset;
            //        }
            //    }
            //}
        }

        protected void Remove(int x, int y, Tile tile)
        {
            byte[] addData = tile._data;

            Rectangle rect = tile.Bound;

            rect.Offset(x, y);
            rect.Intersect(_rect);
            if (rect.Width != 0 && rect.Height != 0)
            {
                rect.Offset(-x, -y);

                int cx = rect.X / 8;
                int cx2 = (rect.X + x) / 8;

                int cy = rect.Y;

                //Tile中n列可以对src中n+1列产生影响,所以cw+1,防止溢出,过滤一下.
                int cw = rect.Width / 8 + 1;
                int ch = rect.Height;

                if (rect.X == 0)
                {
                    if (cw + cx2 < _bw)
                    {
                        cw++;
                        cw = cw > tile._bw ? tile._bw : cw;
                    }
                    int b_offset = (rect.X + x) % 8;

                    int self_offset = 0;
                    int tile_offset = 0;

                    Int32 r_bits = 0;
                    Int32 l_bits = 0;

                    int src = 0;
                    int target = 0;
                    for (int j = 0; j < ch; j++)
                    {
                        r_bits = 0;
                        l_bits = 0;
                        for (int i = 0; i < cw; i++)
                        {
                            self_offset = (j + y + cy) * _bw + i + cx2;
                            tile_offset = (j + cy) * tile._bw + i + cx;

                            src = addData[tile_offset];

                            r_bits = src >> b_offset;

                            target = _data[self_offset];
                            //把target中src为1的位设置位0.
                            target &= ~(target & r_bits);
                            if (l_bits != 0)
                            {
                                target &= ~(target & l_bits);
                            }
                            _data[self_offset] = (byte)target;
                            l_bits = src << 8 - b_offset;
                        }
                    }
                }
                else
                {
                    int b_offset = rect.X % 8;

                    int self_offset = 0;
                    int tile_offset = 0;

                    Int32 r_bits = 0;
                    Int32 l_bits = 0;

                    int src = 0;
                    int target = 0;
                    for (int j = 0; j < ch; j++)
                    {
                        r_bits = 0;
                        l_bits = 0;
                        for (int i = 0; i < cw; i++)
                        {
                            self_offset = (j + y + cy) * _bw + i + cx2;
                            tile_offset = (j + cy) * tile._bw + i + cx;

                            src = addData[tile_offset];
                            l_bits = src << b_offset;
                            if (i < cw - 1)
                            {
                                src = addData[tile_offset + 1];
                                r_bits = src >> (8 - b_offset);
                            }
                            else
                            {
                                r_bits = 0;
                            }
                            target = _data[self_offset];
                            target &= ~(target & l_bits);
                            if (r_bits != 0)
                            {
                                target &= ~(target & r_bits);
                            }
                            _data[self_offset] = (byte)target;
                        }
                    }
                }
            }
        }

        public bool IsEmpty(int x, int y)
        {
            if (x >= 0 && x < _width && y >= 0 && y < _height)
            {
                byte flag = (byte)(0x01 << (7 - x % 8));

                return (_data[y * _bw + x / 8] & flag) == 0;
            }
            else
            {
                return true;
            }
        }

        public bool IsYLineEmtpy(int x, int y, int h)
        {
            if (x >= 0 && x < _width)
            {
                y = y < 0 ? 0 : y;
                h = y + h > _height ? _height - y : h;

                for (int i = 0; i < h; i++)
                {
                    if (!IsEmpty(x, y + i)) return false;
                }
                return true;
            }
            else
            {
                return true;
            }
        }

        public bool IsRectangleEmptyQuick(Rectangle rect)
        {
            rect.Intersect(_rect);
            if (IsEmpty(rect.Right, rect.Bottom) && IsEmpty(rect.Left, rect.Bottom) && IsEmpty(rect.Right, rect.Top) && IsEmpty(rect.Left, rect.Top)) return true;
            return false;
        }

        public Point FindNotEmptyPoint(int x, int y, int h)
        {
            if (x >= 0 && x < _width)
            {
                y = y < 0 ? 0 : y;
                h = y + h > _height ? _height - y : h;

                for (int i = 0; i < h; i++)
                {
                    if (!IsEmpty(x, y + i)) return new Point(x, y + i);
                }
                return new Point(-1, -1);
            }
            else
            {
                return new Point(-1, -1);
            }
        }

        public Bitmap ToBitmap()
        {
            Bitmap bitmap = new Bitmap(_width, _height);

            for (int j = 0; j < _height; j++)
            {
                for (int i = 0; i < _width; i++)
                {
                    if (IsEmpty(i, j))
                    {
                        bitmap.SetPixel(i, j, Color.FromArgb(0, 0, 0, 0));
                    }
                    else
                    {
                        bitmap.SetPixel(i, j, Color.FromArgb(255, 0, 0, 0));
                    }
                }
            }
            return bitmap;
        }

        public Tile Clone()
        {
            return new Tile(_data.Clone() as byte[], _width, _height, _digable);
        }
    }
}