package effortView.leftView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class EffortCategoryTitleItem extends Sprite implements Disposeable
   {
      
      public static const EXPAND:String = "Expand";
      
      public static const SHRINK:String = "shrink";
      
      public static const FULL:String = LanguageMgr.GetTranslation("tank.view.effort.EffortCategoryTitleItem.FULL");
      
      public static const INTEGRATION:String = LanguageMgr.GetTranslation("tank.view.effort.EffortCategoryTitleItem.INTEGRATION");
      
      public static const PART:String = LanguageMgr.GetTranslation("tank.view.effort.EffortCategoryTitleItem.PART");
      
      public static const TASK:String = LanguageMgr.GetTranslation("tank.view.effort.EffortCategoryTitleItem.TASK");
      
      public static const DUNGEON:String = LanguageMgr.GetTranslation("tank.view.effort.EffortCategoryTitleItem.DUNGEON");
      
      public static const FIGHT:String = LanguageMgr.GetTranslation("tank.view.effort.EffortCategoryTitleItem.FIGHT");
      
      public static const HONOR:String = LanguageMgr.GetTranslation("tank.view.effort.EffortCategoryTitleItem.HONOR");
       
      
      private var _bg:ScaleFrameImage;
      
      private var _title:FilterFrameText;
      
      private var _titleII:FilterFrameText;
      
      private var _isExpand:Boolean;
      
      private var _currentType:int;
      
      public function EffortCategoryTitleItem(param1:int)
      {
         this._currentType = param1;
         super();
         this.init();
         this.initEvent();
         this.initTitle();
      }
      
      private function init() : void
      {
         buttonMode = true;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortMainFrame.EffortCategoryTitleItemBG");
         this._bg.mouseEnabled = true;
         this._bg.setFrame(1);
         addChild(this._bg);
         this._title = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortMainFrame.EffortCategoryTitleText_1");
         this._title.visible = true;
         addChild(this._title);
         this._titleII = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortMainFrame.EffortCategoryTitleText_2");
         this._titleII.visible = false;
         addChild(this._titleII);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
      }
      
      private function initTitle() : void
      {
         var _loc1_:String = this.getTypeTitle(this._currentType);
         this._title.text = _loc1_;
         this._titleII.text = _loc1_;
         this._title.mouseEnabled = false;
         this._titleII.mouseEnabled = false;
      }
      
      private function __itemOut(param1:MouseEvent) : void
      {
         if(!this._isExpand)
         {
            this._bg.setFrame(1);
         }
      }
      
      private function __itemOver(param1:MouseEvent) : void
      {
         if(!this._isExpand)
         {
            this._bg.setFrame(2);
         }
      }
      
      public function set selectState(param1:Boolean) : void
      {
         this._isExpand = param1;
         this.updateSelectState();
      }
      
      public function updateSelectState() : void
      {
         if(this._isExpand)
         {
            this._bg.setFrame(3);
            this._titleII.visible = true;
            this._title.visible = false;
         }
         else
         {
            this._bg.setFrame(1);
            this._titleII.visible = false;
            this._title.visible = true;
         }
      }
      
      private function getTypeTitle(param1:int) : String
      {
         switch(param1)
         {
            case 0:
               return FULL;
            case 1:
               return PART;
            case 2:
               return TASK;
            case 3:
               return DUNGEON;
            case 4:
               return FIGHT;
            case 5:
               return INTEGRATION;
            case 6:
               return HONOR;
            default:
               return "null";
         }
      }
      
      public function get contentHeight() : int
      {
         return this.height;
      }
      
      public function get isExpand() : Boolean
      {
         return this._isExpand;
      }
      
      public function get currentType() : int
      {
         return this._currentType;
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         this._bg.dispose();
      }
   }
}
