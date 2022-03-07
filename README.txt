Task Description
You will build a "road-crossing" game. We provide some examples to guide you but you may be creative within the restrictions we describe here.  Please check the two associated grading rubrics for precise details of how marking will occur.  One rubric will be completed by your marker without you present (the "Offline" grading rubric) and the other will be completed during your viva grading session (the "Viva" grading rubric).  

Note: the attached videos are an important part of the description and this page may receive updates to clarify certain points up to 2 weeks before the due date.  Nothing will change, but things may get clarified.

Is our demonstration of the concepts described here.  You are encouraged to create your own graphical style or even to repurpose the mechanics in a new context.  You should submit just one program with as many features as you can get done.  We provide a demo at the bottom of this page.



TEMPLATE PROVIDED
You MUST use the template provided - (right click and save as...) COMP1000MajorWork.pde 

Double-click on the downloaded file. 
You will get a prompt to move the sketch into its own folder. Click on yes to that.
If you download the template a second, third ... times (while the original template is in the same folder), it will append (1), (2) .... to the file. When you click on these, it will NOT work. So, make sure you download to a folder that doesn't already have the file COMP1000MajorWork.pde.

If that doesn't work, you can also open Processing and paste the text from the template file into it, and save the sketch as COMP1000MajorWork so that it automatically creates a folder with the same name and puts the file inside it.

If that doesn't work either, you can ask your tutor or PAL (peer-assisted learning, coming soon) for help.

You must add your code after the last statement in the template provided (final int WIN_SCORE = 10;)

Features Required
We have listed the features you should implement each week by which you will have learned the material to tackle this feature. Note that you do NOT have to submit your work every week. Only two submissions are there - checkpoint and final submission. See unit schedule for exact dates.

Weekly suggested tasks (do not require weekly submissions)

Size: Week 2

The display window in the program you submit must be 1200 pixels wide and 400 pixels high. All subsequent tasks must be done in a scalable manner, using width and height instead of the actual value those system variables hold, so that the program would work even if the display window size was changed from 1200x400 to, say, 900x600.   

Vehicle Design: Week 2

You should have a solid horizontal line at y = height/4. This will be refined down the track. More information as we go along in the session.

You can't just have an ellipse or rectangle for a vehicle. You should have a nicer design to resemble a car/ truck/ bicycle/ motorcycle, etc.

As a guide, you should have at least four to five elements in the vehicle that collectively represent it clearly.

Also, Instead of a vehicle, it can also be some other alternative character, like monsters, space invader characters, asteroids, etc.

There must be a vehicle on the top left of the display window above the solid horizontal line, such that no part of the vehicle is outside the display window, or below the horizontal line.

Instead of using fixed values (like 50, 80, ...), we strongly suggest you use relative values (like height/4, width/8, ...) otherwise refactoring code after subsequent weeks' work is added will be, well, painful.
Note: You can not use images (i.e. PImage, sprites, png, jpg, gif) for your player.  They must be made from Processing shapes (ellipse, circle, square, triangle, arc, etc).

Movement: Week 3

The vehicle should move from the left of the display window to the right and eventually off the screen.

Reset: Week 4

Once the vehicle is completely off the screen, it should "reset". That is, go back to somewhere to the left of the screen. This location should be reasonable so that within the next second or so, it comes back from the left and starts moving to the right of the display window.

Pedestrian: Week 4

A pedestrian should be displayed right down the middle at the bottom of the screen, such that no part of the pedestrian is outside the screen. Again, you can only use Processing shapes and no images. 

Move pedestrian: Week 4

The pedestrian should go up, down, left or right when corresponding keys are pressed. Each time it should move by the height of the lane.

Collision-Detection: Week 5


If the vehicle hits the pedestrian (and this should be reasonably accurate), the pedestrian dies (oh no!) and the game ends. A Game Over screen should be displayed and no further events (keys or mouse) should result in any change.

Lanes: Week 6

The solid horizontal line at y = height/4 from week 2 should be replaced with a dashed line. 

Scoring: Week 7

Each time the pedestrian successfully crosses the lane (goes above the display window), the score should increase by 1 and get displayed on the bottom right corner of the screen.

Refactoring into functions: Week 8

You should identify sections of your code that belong to a function and extract them into the same. Instead of having 100 lines of code inside draw(), this will enable you to have multiple functions whose names clearly communicate their purpose, and the draw() function will call these functions. It's also possible that some of these functions call one or more of the other functions.

If you pass the parameters to functions, rather than operating on global variables, your weeks 10 to 12 tasks will become much easier.

This will have implications for your week 10 task. If you do this properly, week 10 becomes much easier.

Lives left, Victory: Week 9

Instead of the pedestrian dying upon the very first collision, introduce the concept of "lives left". The pedestrian has MAX_LIVES lives and each time it collides with a car, the number of lives left decreases by 1, and it comes back to the original position. After the third collision, the game over screen should appear (with "Game Over!" screen)

Secondly, add a "You win!" screen, that is displayed if and when the score reaches WIN_SCORE.
Multiple vehicles in the same lane: Week 10

Instead of having just one vehicle, now there should be N_CARS_IN_LANE vehicles in the same lane. For pass-level, it's ok for the vehicles to overtake each other. Imagine that this is the top-view and the vehicles are air-borne and can fly over or under each other. For higher grades, this should be avoided. In the demo, a distance gauge is displayed and as soon as a vehicle comes within MIN_GAP pixels of the one in front of it, it slows down to match the speed of the vehicle in front.

Multiple Lanes: Weeks 11, 12

Instead of having just one lane, there should be multiple lanes. This should be controlled by a single global variable N_LANES. You may assume that 1 <= N_LANES <= 10. If N_LANES = 1, there is 1 lane (easiest); if N_LANES = 10, there are 10 lanes (hardest). Again, for higher grades, the vehicles should not overtake each other. In the demo, we have numbered the cars using the format <lane number> followed by <car number> where all numberings begin from 0. So the first car in the first lane is 00, while the fourth car in the second lane is 13. The number of cars in each lane is limited to 10.

Remember, that dashed line we drew at y = height/4. That was with the assumption that N_LANES = 2. We want all (N_LANES) vehicles in the top half of the display window. You should draw the lanes in a way that changing the single variable N_LANES (or dimensions of the display window) will result in the height of the lanes getting adjusted. 


Constraints
Why do these exist?

You cannot use any extra processing libraries or plugins
You cannot define your own classes. You can use PVector class.
You cannot use multiple tabs or multiple files
You cannot use transformations such as rotate, translate, scale
You cannot use images
You must submit a single .pde file named exactly COMP1000MajorWork.pde (not COMP1000 Major Work.pde, not COMP1000MajorWork (1).pde, not aladdin.pde...)