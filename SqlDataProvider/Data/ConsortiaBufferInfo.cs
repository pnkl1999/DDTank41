using System;

namespace SqlDataProvider.Data
{
    public class ConsortiaBufferInfo
    {
        public int ConsortiaID { get; set; }

        public int BufferID { get; set; }

        public DateTime BeginDate { get; set; }

        public int ValidDate { get; set; }

        public bool IsOpen { get; set; }

        public int Type { get; set; }

        public int Value { get; set; }
    }
}
