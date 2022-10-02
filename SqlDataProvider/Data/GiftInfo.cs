using System;
using System.Collections.Generic;

namespace SqlDataProvider.Data
{
    public class GiftInfo : DataObject
    {
        private DateTime _addDate;

        private int _count;

        private int _itemID;

        private Dictionary<string, object> _tempInfo = new Dictionary<string, object>();

        private ItemTemplateInfo _template;

        private int _templateId;

        private int _userID;

        public DateTime AddDate
        {
			get
			{
				return _addDate;
			}
			set
			{
				if (!(_addDate == value))
				{
					_addDate = value;
					_isDirty = true;
				}
			}
        }

        public int Count
        {
			get
			{
				return _count;
			}
			set
			{
				if (_count != value)
				{
					_count = value;
					_isDirty = true;
				}
			}
        }

        public int ItemID
        {
			get
			{
				return _itemID;
			}
			set
			{
				_itemID = value;
				_isDirty = true;
			}
        }

        public Dictionary<string, object> TempInfo=> _tempInfo;

        public ItemTemplateInfo Template=> _template;

        public int TemplateID
        {
			get
			{
				return _templateId;
			}
			set
			{
				if (_templateId != value)
				{
					_templateId = value;
					_isDirty = true;
				}
			}
        }

        public int UserID
        {
			get
			{
				return _userID;
			}
			set
			{
				if (_userID != value)
				{
					_userID = value;
					_isDirty = true;
				}
			}
        }

        internal GiftInfo(ItemTemplateInfo template)
        {
			_template = template;
			if (_template != null)
			{
				_templateId = _template.TemplateID;
			}
			if (_tempInfo == null)
			{
				_tempInfo = new Dictionary<string, object>();
			}
        }

        public bool CanStackedTo(GiftInfo to)
        {
			if (_templateId == to.TemplateID)
			{
				return Template.MaxCount > 1;
			}
			return false;
        }

        public static GiftInfo CreateFromTemplate(ItemTemplateInfo template, int count)
        {
			if (template == null)
			{
				throw new ArgumentNullException("template");
			}
			return new GiftInfo(template)
			{
				TemplateID = template.TemplateID,
				IsDirty = false,
				AddDate = DateTime.Now,
				Count = count
			};
        }

        public static GiftInfo CreateWithoutInit(ItemTemplateInfo template)
        {
			return new GiftInfo(template);
        }
    }
}
