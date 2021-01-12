# using the homography matrix to perform perspective transform
# an example using a sudoku image

import cv2
import numpy as np
import matplotlib.pyplot as plt

img = cv2.imread('sudoku.jpg')                                        # read image

origpts = np.float32([[56,65],[368,52],[28,387],[389,390]])           # four points on the original image - manually obtained corners
newpts = np.float32([[0,0],[300,0],[0,300],[300,300]])                # four points on the new image - a desired 300x300 image

H = cv2.getPerspectiveTransform(origpts,newpts)                       # get the homography matrix
print(H)

dst = cv2.warpPerspective(img, H, (300,300))                          # perform the perspective transform

fig, (ax1, ax2) = plt.subplots(figsize = (18, 10), ncols = 2)         # show
ax1.imshow(img), ax1.set_title("Original")
ax2.imshow(dst), ax2.set_title("Transformed")
plt.show() 