using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class ServerDataInfo : DataObject
    {
        private string _Name;

        public string Name
        {
            get { return _Name; }
            set { _Name = value; _isDirty = true; }
        }

        private string _ValString;

        public string ValString
        {
            get { return _ValString; }
            set { _ValString = value; _isDirty = true; }
        }

        private int _ValInt;

        public int ValInt
        {
            get { return _ValInt; }
            set { _ValInt = value; _isDirty = true; }
        }

        private DateTime _ValDateTime;

        public DateTime ValDateTime
        {
            get { return _ValDateTime; }
            set { _ValDateTime = value; _isDirty = true; }
        }

        private byte[] _ValBinary;

        public byte[] ValBinary
        {
            get { return _ValBinary; }
            set { _ValBinary = value; _isDirty = true; }
        }


    }
}
