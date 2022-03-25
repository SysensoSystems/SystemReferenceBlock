# SystemReferenceBlock

System Reference Block helps to refer a model or system or sub-system within another model or system. This block overcomes the limitation of Model Reference and combines the advanatages of Library Reference.
Advantages of using System Reference block over conventional Model Reference Block:
 * Referenced model configuration settings will not affect the model reference usage
 * System Reference Block just copies the logic of the desired system as like library reference, whereas Model Reference block actually refers the system selected.
 * Virtual bus can pass the model boundries.
 * Goto and From blocks can cross system reference boundaries.
 * With System Reference block, we need reference Model or Subsystem.

Usage:
If this SystemReferenceBlock folder is in MATLAB path, then the library block named as System Reference  will be available to use from Simulink Library Browser.
There is one block "System Reference" available in this library.
1. In System Reference, only logic is copied. So when this block is viewed under mask, the selected model
   will be placed into this block.
2. In Model Reference, the selected Model is referred. So when this block is viewed under mask, the
   selected model will be referred as Model Reference block into this block.
3. In Sub-systrem reference, only logic of sub-system is copied. So when this block is viewed under mask,
   the selected sub-system contents will be placed into this block.
Detailed help can be found from the following document "SystemReferenceBlock\docs\SystemReference_doc.pdf".


MATLAB Release Compatibility: Created with R2015b, Compatible with any release


Developed by: Sysenso Systems, https://sysenso.com/

Contact: contactus@sysenso.com

Note: Please share your comments and contact us if you are interested in updating the features further.
