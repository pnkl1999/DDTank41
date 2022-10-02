using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class UsersPetFormInfo : DataObject
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
        private int _petsID;
        public int PetsID
        {
            get { return _petsID; }
            set { _petsID = value; _isDirty = true; }
        }
        private string _activePets;
        public string ActivePets
        {
            get { return _activePets; }
            set { _activePets = value; _isDirty = true; }
        }
    }
}