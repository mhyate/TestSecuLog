describe('Reservations', () => {
  beforeEach(() => {
    cy.login('test@example.com', 'password123')
    cy.visit('/app/reservations')
  })

  it('should display reservations list', () => {
    cy.contains('Mes Réservations').should('be.visible')
    cy.get('ul').should('exist')
  })

  it('should navigate to new reservation', () => {
    cy.get('a').contains('Nouvelle réservation').click()
    cy.url().should('include', '/app/equipment')
  })

  it('should show reservation details', () => {
    cy.get('ul > li').first().within(() => {
      cy.get('img').should('be.visible')
      cy.get('h2').should('be.visible')
      cy.get('span').should('be.visible') // Status badge
    })
  })

  it('should allow canceling pending reservations', () => {
    cy.get('ul > li').first().within(() => {
      cy.get('span').contains('En attente').should('exist')
      cy.get('button').contains('X').click()
    })
    cy.contains('Réservation annulée avec succès').should('be.visible')
  })
})