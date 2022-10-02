using System;

namespace SqlDataProvider.Data
{
    public class UserGiftInfo
    {
        public int ID { get; set; }

        public int SenderID { get; set; }

        public int ReceiverID { get; set; }

        public int TemplateID { get; set; }

        public int Count { get; set; }

        public DateTime CreateDate { get; set; }

        public DateTime LastUpdate { get; set; }
    }
}
