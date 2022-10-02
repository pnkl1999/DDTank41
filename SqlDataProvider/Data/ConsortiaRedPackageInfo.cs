using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class ConsortiaRedPackageInfo : DataObject
    {
        private int _ID;

        public int ID
        {
            get { return _ID; }
            set { _ID = value; _isDirty = true; }
        }

        private int _ConsortiaID;

        public int ConsortiaID
        {
            get { return _ConsortiaID; }
            set { _ConsortiaID = value; _isDirty = true; }
        }
        
        private int _UserID;

        public int UserID
        {
            get { return _UserID; }
            set { _UserID = value; _isDirty = true; }
        }

        private string _NickName;

        public string NickName
        {
            get { return _NickName; }
            set { _NickName = value; _isDirty = true; }
        }

        private int _Money;

        public int Money
        {
            get { return _Money; }
            set { _Money = value; _isDirty = true; }
        }
        private int _Package;

        public int Package
        {
            get { return _Package; }
            set { _Package = value; _isDirty = true; }
        }
        private string _WishWord;

        public string WishWord
        {
            get { return _WishWord; }
            set { _WishWord = value; _isDirty = true; }
        }
        private string _ReceiveData;

        public string ReceiveData
        {
            get { return _ReceiveData; }
            set { _ReceiveData = value; _isDirty = true; }
        }

        private DateTime _TimeCreate;

        public DateTime TimeCreate
        {
            get { return _TimeCreate; }
            set { _TimeCreate = value; _isDirty = true; }
        }

    }
}
