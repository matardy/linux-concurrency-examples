/* TCPmtechod.c - main, TCPechod, prstats */

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>

#include <sys/types.h>
#include <sys/signal.h>
#include <sys/socket.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <sys/errno.h>
#include <netinet/in.h>

#define	QLEN		  32	/* maximum connection queue length	*/
#define	BUFSIZE		4096

#define	INTERVAL	5	/* secs */

int	TCPechod(int fd);
int	errexit(const char *format, ...);
int	passiveTCP(const char *service, int qlen);

/*------------------------------------------------------------------------
 * main - Concurrent TCP server for ECHO service
 *------------------------------------------------------------------------
 */
int
main(int argc, char *argv[]) {
  pthread_t	th;
  pthread_attr_t	ta;
  char	*service = "echo";	/* service name or port number	*/
  struct	sockaddr_in fsin;	/* the address of a client	*/
  unsigned int	alen;		/* length of client's address	*/
  int	msock;			/* master server socket		*/
  int	ssock;			/* slave server socket		*/

  switch (argc) {
    case	1:
    break;
    case	2:
    service = argv[1];
    break;
    default:
      errexit("usage: TCPechod [port]\n");
  }

  msock = passiveTCP(service, QLEN);

  (void) pthread_attr_init(&ta);
  (void) pthread_attr_setdetachstate(&ta, PTHREAD_CREATE_DETACHED);

  while (1) {
    alen = sizeof(fsin);
    ssock = accept(msock, (struct sockaddr *)&fsin, &alen);
    if (ssock < 0) {
      if (errno == EINTR)
      continue;
      errexit("accept: %s\n", strerror(errno));
    }
    if (pthread_create(&th, &ta, (void *(*)(void *))TCPechod,(void *)ssock) < 0)
      errexit("pthread_create: %s\n", strerror(errno));
  }
}

/*------------------------------------------------------------------------
 * TCPechod - echo data until end of file
 *------------------------------------------------------------------------
 */
int
TCPechod(int fd) {
  char	buf[BUFSIZ];
  int	cc;

  while (cc = read(fd, buf, sizeof buf)) {
    if (cc < 0)
      errexit("echo read: %s\n", strerror(errno));
    if (write(fd, buf, cc) < 0)
      errexit("echo write: %s\n", strerror(errno));
  }
  (void) close(fd);
  return 0;
}

