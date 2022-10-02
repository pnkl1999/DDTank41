using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class AdornInfo : DataObject
    {
        private int _ID;
        public int ID
        {
            get { return _ID; }
            set { _ID = value; _isDirty = true; }
        }
        private int _userID;
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; _isDirty = true; }
        }
        private int _templateId;
        public int TemplateId
        {
            get { return _templateId; }
            set { _templateId = value; _isDirty = true; }
        }
        private int _category;
        public int Category
        {
            get { return _category; }
            set { _category = value; _isDirty = true; }
        }
    }
}
