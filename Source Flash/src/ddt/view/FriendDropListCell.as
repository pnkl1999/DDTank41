package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IDropListCell;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import ddt.view.common.SexIcon;
   
   public class FriendDropListCell extends Component implements IDropListCell
   {
       
      
      private var _sex_icon:SexIcon;
      
      private var _data:String;
      
      private var _textField:FilterFrameText;
      
      private var _selected:Boolean;
      
      private var _bg:ScaleFrameImage;
      
      public function FriendDropListCell()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("droplist.CellBg");
         this._textField = ComponentFactory.Instance.creatComponentByStylename("droplist.CellText");
         this._sex_icon = new SexIcon();
         PositionUtils.setPos(this._sex_icon,"IM.IMLookup.SexPos");
         this._bg.setFrame(1);
         width = this._bg.width;
         height = this._bg.height;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._bg)
         {
            addChild(this._bg);
         }
         if(this._textField)
         {
            addChild(this._textField);
         }
         if(this._sex_icon)
         {
            addChild(this._sex_icon);
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         if(this._selected)
         {
            this._bg.setFrame(2);
         }
         else
         {
            this._bg.setFrame(1);
         }
      }
      
      public function getCellValue() : *
      {
         if(this._data)
         {
            return (this._data as PlayerInfo).NickName;
         }
         return "";
      }
      
      public function setCellValue(param1:*) : void
      {
         this._data = param1;
         if(param1)
         {
            this._textField.text = param1.NickName;
            this._sex_icon.visible = true;
            this._sex_icon.setSex(param1.Sex);
         }
         else
         {
            this._textField.text = LanguageMgr.GetTranslation("ddt.FriendDropListCell.noFriend");
            this._sex_icon.visible = false;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._sex_icon)
         {
            ObjectUtils.disposeObject(this._sex_icon);
         }
         this._sex_icon = null;
         if(this._textField)
         {
            ObjectUtils.disposeObject(this._textField);
         }
         this._textField = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
