package times.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import times.TimesController;
   import times.data.TimesEvent;
   import times.data.TimesPicInfo;
   
   public class TimesMenuView extends Sprite implements Disposeable
   {
       
      
      protected var _vBox:VBox;
      
      protected var _btnGroup:SelectedButtonGroup;
      
      protected var _menus:Vector.<SelectedButton>;
      
      protected var _infos:Vector.<TimesPicInfo>;
      
      public function TimesMenuView()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("times.MenuContainer");
         this._menus = new Vector.<SelectedButton>(4);
         this._infos = new Vector.<TimesPicInfo>(4);
         var _loc1_:int = 0;
         while(_loc1_ < this._menus.length)
         {
            this._menus[_loc1_] = ComponentFactory.Instance.creatComponentByStylename("times.MenuButton_" + String(_loc1_ + 1));
            this._vBox.addChild(this._menus[_loc1_]);
            this._infos[_loc1_] = new TimesPicInfo();
            this._infos[_loc1_].type = "category" + String(_loc1_);
            this._infos[_loc1_].targetCategory = _loc1_;
            this._infos[_loc1_].targetPage = 0;
            _loc1_++;
         }
         this._btnGroup = new SelectedButtonGroup();
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            this._btnGroup.addSelectItem(this._menus[_loc2_]);
            _loc2_++;
         }
         this._btnGroup.selectIndex = 0;
         this._btnGroup.addEventListener(Event.CHANGE,this.__btnChangeHandler);
         addChild(this._vBox);
      }
      
      public function set selected(param1:int) : void
      {
         this._btnGroup.selectIndex = param1;
      }
      
      private function __btnChangeHandler(param1:Event) : void
      {
         TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.PLAY_SOUND));
         TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.GOTO_CONTENT,this._infos[this._btnGroup.selectIndex]));
      }
      
      public function dispose() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__btnChangeHandler);
         var _loc1_:int = 0;
         while(_loc1_ < this._menus.length)
         {
            this._infos[_loc1_] = null;
            _loc1_++;
         }
         ObjectUtils.disposeObject(this._vBox);
         this._vBox = null;
         this._menus = null;
         this._infos = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
