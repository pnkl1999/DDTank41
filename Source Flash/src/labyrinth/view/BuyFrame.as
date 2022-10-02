package labyrinth.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import labyrinth.LabyrinthManager;
   
   public class BuyFrame extends BaseAlerFrame
   {
       
      
      private var _selectedCheckButton:SelectedCheckButton;
      
      private var _content:FilterFrameText;
      
      private var _value:int;
      
      public function BuyFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         info = new AlertInfo(LanguageMgr.GetTranslation("labyrinth.view.buyFrame.title"));
         this._content = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthFrame.BuyFrameContentText");
         addToContent(this._content);
         this._selectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthFrame.BuyFrameSelectedCheckButton");
         this._selectedCheckButton.text = LanguageMgr.GetTranslation("labyrinth.view.buyFrame.SelectedCheckButtonText");
         this._selectedCheckButton.addEventListener(MouseEvent.CLICK,this.__onselectedCheckButtoClick);
         addToContent(this._selectedCheckButton);
      }
      
      protected function __onselectedCheckButtoClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         LabyrinthManager.Instance.buyFrameEnable = !this._selectedCheckButton.selected;
      }
      
      public function show() : void
      {
         this._content.text = LanguageMgr.GetTranslation("labyrinth.view.buyFrame.content",this._value);
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function set value(param1:int) : void
      {
         this._value = param1;
      }
      
      override public function dispose() : void
      {
         if(this._selectedCheckButton)
         {
            this._selectedCheckButton.removeEventListener(MouseEvent.CLICK,this.__onselectedCheckButtoClick);
         }
         ObjectUtils.disposeObject(this._selectedCheckButton);
         this._selectedCheckButton = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         super.dispose();
      }
   }
}
