#include <iostream>
#include <string>
#include <cmath>

using namespace std;

int main(void) {
  int deg, dis;
  cin >> deg >> dis;

  string res = "";
  double dir = (deg / 10.0 + 11.25) / 22.5;
  if (dir < 1 || dir >= 16) {
    res += "N ";
  } else if (dir < 2) {
    res += "NNE ";
  } else if (dir < 3) {
    res += "NE ";
  } else if (dir < 4) {
    res += "ENE ";
  } else if (dir < 5) {
    res += "E ";
  } else if (dir < 6) {
    res += "ESE ";
  } else if (dir < 7) {
    res += "SE ";
  } else if (dir < 8) {
    res += "SSE ";
  } else if (dir < 9) {
    res += "S ";
  } else if (dir < 10) {
    res += "SSW ";
  } else if (dir < 11) {
    res += "SW ";
  } else if (dir < 12) {
    res += "WSW ";
  } else if (dir < 13) {
    res += "W ";
  } else if (dir < 14) {
    res += "WNW ";
  } else if (dir < 15) {
    res += "NW ";
  } else {
    res += "NNW ";
  }

  double w = dis / 60.0;
  w = round(w * 10.0) / 10.0;
  if (w <= 0.2) {
    res = "C 0";
  } else if (w <= 1.5) {
    res += "1";
  } else if (w <= 3.3) {
    res += "2";
  } else if (w <= 5.4) {
    res += "3";
  } else if (w <= 7.9) {
    res += "4";
  } else if (w <= 10.7) {
    res += "5";
  } else if (w <= 13.8) {
    res += "6";
  } else if (w <= 17.1) {
    res += "7";
  } else if (w <= 20.7) {
    res += "8";
  } else if (w <= 24.4) {
    res += "9";
  } else if (w <= 28.4) {
    res += "10";
  } else if (w <= 32.6) {
    res += "11";
  } else {
    res += "12";
  } 

  cout << res << endl;
  return 0;
}
