using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class SXCellDataInfo
    {
        public int row { get; set; }
        public int column { get; set; }
        public int type { get; set; }
        public bool isLocked { get; set; }

        public SXCellDataInfo(int _row, int _col)
        {
            row = _row;
            column = _col;
            type = 0;
            isLocked = false;
        }
    }
}
