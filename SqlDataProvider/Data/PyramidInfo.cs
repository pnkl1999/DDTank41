using System;

namespace SqlDataProvider.Data
{

    public class PyramidInfo : DataObject
    {
        private int _ID;
        public int ID
        {
            get
            {
                return _ID;
            }
            set
            {
                _ID = value;
                _isDirty = true;
            }
        }

        private int _userID;         
        public int UserID
        {
            get
            {
                return _userID;
            }
            set
            {
                _userID = value;
                _isDirty = true;
            }
        }

        private int _currentLayer;
        public int currentLayer
        {
            get
            {
                return _currentLayer;
            }
            set
            {
                _currentLayer = value;
                _isDirty = true;
            }
        }

        private int _maxLayer;
        public int maxLayer
        {
            get
            {
                return _maxLayer;
            }
            set
            {
                _maxLayer = value;
                _isDirty = true;
            }
        }

        private int _totalPoint;
        public int totalPoint
        {
            get
            {
                return _totalPoint;
            }
            set
            {
                _totalPoint = value;
                _isDirty = true;
            }
        }

        private int _turnPoint;
        public int turnPoint
        {
            get
            {
                return _turnPoint;
            }
            set
            {
                _turnPoint = value;
                _isDirty = true;
            }
        }

        private int _pointRatio;
        public int pointRatio
        {
            get
            {
                return _pointRatio;
            }
            set
            {
                _pointRatio = value;
                _isDirty = true;
            }
        }
        private int _currentFreeCount;
        public int currentFreeCount
        {
            get
            {
                return _currentFreeCount;
            }
            set
            {
                _currentFreeCount = value;
                _isDirty = true;
            }
        }

        private bool _isPyramidStart;
        public bool isPyramidStart
        {
            get
            {
                return _isPyramidStart;
            }
            set
            {
                _isPyramidStart = value;
                _isDirty = true;
            }
        }
        private string _LayerItems;
        public string LayerItems
        {
            get
            {
                return _LayerItems;
            }
            set
            {
                _LayerItems = value;
                _isDirty = true;
            }
        }
        private int _currentReviveCount;
        public int currentReviveCount
        {
            get
            {
                return _currentReviveCount;
            }
            set
            {
                _currentReviveCount = value;
                _isDirty = true;
            }
        }        
    }
}

