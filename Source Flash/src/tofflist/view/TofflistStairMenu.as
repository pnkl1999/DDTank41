package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   
   public class TofflistStairMenu extends Sprite implements Disposeable
   {
      
      public static const CONSORTIA:String = "consortia";
      
      public static const CROSS_SERVER_CONSORTIA:String = "crossServerConsortia";
      
      public static const CROSS_SERVER_PERSONAL:String = "crossServerPersonal";
      
      public static const PERSONAL:String = "personal";
       
      
      private var _selectedBtnGroupI:SelectedButtonGroup;
      
      private var _crossServerBtn:SelectedCheckButton;
      
      private var _theServerBtn:SelectedCheckButton;
      
      private var _selectedBtnGroupII:SelectedButtonGroup;
      
      private var _consortiaBtn:SelectedButton;
      
      private var _personalBtn:SelectedButton;
      
      private var _resourceArr:Array;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _styleLinkArr:Array;
      
      public function TofflistStairMenu()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._selectedBtnGroupI = new SelectedButtonGroup(false,1);
         this._theServerBtn = ComponentFactory.Instance.creatComponentByStylename("tofflist.theServerBtn");
         this._selectedBtnGroupI.addSelectItem(this._theServerBtn);
         addChild(this._theServerBtn);
         this._crossServerBtn = ComponentFactory.Instance.creatComponentByStylename("tofflist.crossServerBtn");
         this._selectedBtnGroupI.addSelectItem(this._crossServerBtn);
         addChild(this._crossServerBtn);
         this._selectedBtnGroupI.selectIndex = 0;
         this._selectedBtnGroupII = new SelectedButtonGroup(false,1);
         this._personalBtn = ComponentFactory.Instance.creatComponentByStylename("tofflist.personalBtn");
         this._selectedBtnGroupII.addSelectItem(this._personalBtn);
         addChild(this._personalBtn);
         this._consortiaBtn = ComponentFactory.Instance.creatComponentByStylename("tofflist.consortiaBtn");
         this._selectedBtnGroupII.addSelectItem(this._consortiaBtn);
         addChild(this._consortiaBtn);
         this._selectedBtnGroupII.selectIndex = 0;
      }
      
      private function addEvent() : void
      {
         this._selectedBtnGroupI.addEventListener(Event.CHANGE,this.__typeChange);
         this._selectedBtnGroupII.addEventListener(Event.CHANGE,this.__typeChange);
      }
      
      private function __typeChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedBtnGroupI.selectIndex == 0 && this._selectedBtnGroupII.selectIndex == 0)
         {
            this.type = TofflistStairMenu.PERSONAL;
         }
         else if(this._selectedBtnGroupI.selectIndex == 1 && this._selectedBtnGroupII.selectIndex == 0)
         {
            this.type = TofflistStairMenu.CROSS_SERVER_PERSONAL;
         }
         else if(this._selectedBtnGroupI.selectIndex == 0 && this._selectedBtnGroupII.selectIndex == 1)
         {
            this.type = TofflistStairMenu.CONSORTIA;
         }
         else if(this._selectedBtnGroupI.selectIndex == 1 && this._selectedBtnGroupII.selectIndex == 1)
         {
            this.type = TofflistStairMenu.CROSS_SERVER_CONSORTIA;
         }
      }
      
      private function removeEvent() : void
      {
         this._selectedBtnGroupI.removeEventListener(Event.CHANGE,this.__typeChange);
         this._selectedBtnGroupII.removeEventListener(Event.CHANGE,this.__typeChange);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._selectedBtnGroupI)
         {
            this._selectedBtnGroupI.dispose();
         }
         this._selectedBtnGroupI = null;
         if(this._selectedBtnGroupII)
         {
            this._selectedBtnGroupII.dispose();
         }
         this._selectedBtnGroupII = null;
         if(this._theServerBtn)
         {
            this._theServerBtn.dispose();
         }
         this._theServerBtn = null;
         if(this._crossServerBtn)
         {
            this._crossServerBtn.dispose();
         }
         this._crossServerBtn = null;
         if(this._personalBtn)
         {
            this._personalBtn.dispose();
         }
         this._personalBtn = null;
         if(this._consortiaBtn)
         {
            this._consortiaBtn.dispose();
         }
         this._consortiaBtn = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get type() : String
      {
         return TofflistModel.firstMenuType;
      }
      
      public function set type(param1:String) : void
      {
         TofflistModel.firstMenuType = param1;
         dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.type));
      }
   }
}
