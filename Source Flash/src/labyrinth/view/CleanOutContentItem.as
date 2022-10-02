package labyrinth.view
{
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import labyrinth.LabyrinthManager;
   import labyrinth.data.CleanOutInfo;
   
   public class CleanOutContentItem extends Sprite implements IListCell
   {
       
      
      private var _expNum:FilterFrameText;
      
      private var _floorNumContent:FilterFrameText;
      
      private var _info:CleanOutInfo;
      
      public function CleanOutContentItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._expNum = UICreatShortcut.creatTextAndAdd("ddt.labyrinth.CleanOutContentItem.expNum","",this);
         this._floorNumContent = UICreatShortcut.creatTextAndAdd("ddt.labyrinth.CleanOutContentItem.floorNumContent","",this);
         var _loc1_:int = LabyrinthManager.Instance.model.currentFloor == 0 ? int(int(LabyrinthManager.Instance.model.currentFloor + 1)) : int(int(LabyrinthManager.Instance.model.currentFloor));
         this._floorNumContent.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutItem.ValueTextII",_loc1_);
         LabyrinthManager.Instance.addEventListener(LabyrinthManager.UPDATE_INFO,this.__updateInfo);
      }
      
      protected function __updateInfo(param1:Event) : void
      {
         this.updateItem();
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._info = param1 as CleanOutInfo;
         this.updateItem();
      }
      
      private function updateItem() : void
      {
         var _loc3_:int = 0;
         if(!this._info)
         {
            _loc3_ = LabyrinthManager.Instance.model.currentFloor == 0 ? int(int(LabyrinthManager.Instance.model.currentFloor + 1)) : int(int(LabyrinthManager.Instance.model.currentFloor));
            this._floorNumContent.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutItem.ValueTextII",_loc3_);
            this._expNum.text = "";
            return;
         }
         this._expNum.text = LanguageMgr.GetTranslation("tank.fightLib.FightLibAwardView.exp") + this._info.exp.toString();
         this._floorNumContent.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutItem.ValueText",this._info.FamRaidLevel);
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < this._info.TemplateIDs.length)
         {
            _loc1_ += "," + ItemManager.Instance.getTemplateById(this._info.TemplateIDs[_loc2_]["TemplateID"]).Name;
            if(this._info.TemplateIDs[_loc2_]["num"] != 0)
            {
               _loc1_ += "x" + this._info.TemplateIDs[_loc2_]["num"].toString();
            }
            _loc2_++;
         }
         if(this._info.HardCurrency > 0)
         {
            _loc1_ += LanguageMgr.GetTranslation("dt.labyrinth.CleanOutContentItem.HardCurrency",this._info.HardCurrency);
         }
         this._expNum.text += _loc1_;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         LabyrinthManager.Instance.removeEventListener(LabyrinthManager.UPDATE_INFO,this.__updateInfo);
         ObjectUtils.disposeObject(this._expNum);
         this._expNum = null;
         ObjectUtils.disposeObject(this._floorNumContent);
         this._floorNumContent = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
