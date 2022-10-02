using System;
using System.Collections.Generic;
using System.Text;
namespace SqlDataProvider.Data
{
    public class GypsyItemDataInfo : DataObject
    {
        private int _iD;
        public int ID
        {
            get { return _iD; }
            set { _iD = value; _isDirty = true; }
        }
        private int _userID;
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; _isDirty = true; }
        }
        private int _gypsyID;
        public int GypsyID
        {
            get { return _gypsyID; }
            set { _gypsyID = value; _isDirty = true; }
        }
        private int _infoID;
        public int InfoID
        {
            get { return _infoID; }
            set { _infoID = value; _isDirty = true; }
        }
        private int _unit;
        public int Unit
        {
            get { return _unit; }
            set { _unit = value; _isDirty = true; }
        }
        private int _num;
        public int Num
        {
            get { return _num; }
            set { _num = value; _isDirty = true; }
        }
        private int _type;
        public int type
        {
            get { return _type; }
            set { _type = value; _isDirty = true; }
        }
        private int _price;
        public int Price
        {
            get { return _price; }
            set { _price = value; _isDirty = true; }
        }
        private int _canBuy;
        public int CanBuy
        {
            get { return _canBuy; }
            set { _canBuy = value; _isDirty = true; }
        }
        private int _quality;
        public int Quality
        {
            get { return _quality; }
            set { _quality = value; _isDirty = true; }
        }
    }
}