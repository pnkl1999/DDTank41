package login.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.Role;
   import ddt.view.common.LevelIcon;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class RoleItem extends Sprite implements Disposeable, IListCell
   {
       
      
      private var _selected:Boolean = false;
      
      private var _roleInfo:Role;
      
      private var _backImage:ScaleFrameImage;
      
      private var _levelIcon:LevelIcon;
      
      private var _nicknameField:FilterFrameText;
      
      private var _data:Object;
      
      public function RoleItem()
      {
         super();
         mouseChildren = false;
         buttonMode = true;
         this.configUi();
      }
      
      private function configUi() : void
      {
         this._backImage = ComponentFactory.Instance.creatComponentByStylename("login.ChooseRole.RoleBackground");
         addChild(this._backImage);
         DisplayUtils.setFrame(this._backImage,1);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("login.ChooseRole.cell.LevelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._nicknameField = ComponentFactory.Instance.creatComponentByStylename("login.ChooseRole.Nickname");
         addChild(this._nicknameField);
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected != param1)
         {
            this._selected = param1;
            if(this._selected)
            {
               DisplayUtils.setFrame(this._backImage,2);
            }
            else
            {
               DisplayUtils.setFrame(this._backImage,1);
            }
         }
      }
      
      public function get roleInfo() : Role
      {
         return this._roleInfo;
      }
      
      public function set roleInfo(param1:Role) : void
      {
         this._roleInfo = param1;
         this._levelIcon.setInfo(this._roleInfo.Grade,0,this._roleInfo.WinCount,this._roleInfo.TotalCount,1,0);
         this._nicknameField.text = this._roleInfo.NickName;
      }
      
      public function dispose() : void
      {
         if(this._backImage)
         {
            ObjectUtils.disposeObject(this._backImage);
            this._backImage = null;
         }
         if(this._levelIcon)
         {
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
         }
         if(this._nicknameField)
         {
            ObjectUtils.disposeObject(this._nicknameField);
            this._nicknameField = null;
         }
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._data = param1;
         this.roleInfo = this._data as Role;
      }
   }
}
